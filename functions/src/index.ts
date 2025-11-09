// Firebase Functions v2 사용 (Gen 2)
import {onDocumentUpdated} from 'firebase-functions/v2/firestore';
import * as admin from 'firebase-admin';

// Firebase Admin SDK 초기화
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ============================================================================
// 🚗 라이드 상태가 pending → active로 변경될 때 모든 드라이버에게 알림
// ============================================================================
/**
 * 트리거: rideRequests/{rideType}/items/{rideId} 문서가 업데이트될 때
 * 조건: status가 pending → active로 변경
 * 대상: 모든 등록된 드라이버 (drivers 컬렉션)
 * 
 * 왜: 승객들이 택시팟을 완성하면 모든 드라이버가 요청을 보고 수락할 수 있어야 함
 * 
 * Gen 2 함수로 작성 (더 빠르고 효율적)
 */
export const onNewRideRequest = onDocumentUpdated(
  'rideRequests/{rideType}/items/{rideId}',
  async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();
    
    if (!beforeData || !afterData) {
      console.log('문서 데이터가 없습니다');
      return;
    }

    const { rideType, rideId } = event.params;

    try {
      console.log('🔄 [드라이버 알림] 라이드 업데이트 감지:', {
        rideType,
        rideId,
        beforeStatus: beforeData.status,
        afterStatus: afterData.status,
      });

      // ✅ 체크 1: status가 pending → active로 변경되었는지 확인
      // 이유: 승객들이 모여서 택시팟을 완성하고 드라이버에게 요청할 때만 알림
      if (beforeData.status !== 'pending' || afterData.status !== 'active') {
        console.log('⏭️ 스킵: status 변경이 pending → active가 아님');
        return;
      }

      console.log('✅ 새로운 라이드 요청 감지! 모든 드라이버에게 브로드캐스트 시작...');

      // ✅ 체크 2: drivers 컬렉션에서 모든 드라이버 조회
      // 이유: 아직 특정 드라이버가 배정되지 않았으므로, 모든 드라이버가 볼 수 있어야 함
      console.log('🔍 모든 드라이버 조회 중...');
      const driversSnapshot = await db.collection('drivers').get();

      if (driversSnapshot.empty) {
        console.warn('⚠️ 등록된 드라이버가 없습니다');
        return;
      }

      console.log(`📋 총 ${driversSnapshot.size}명의 드라이버 발견`);

      // ✅ 체크 3: 각 드라이버의 FCM 토큰 수집
      // 이유: FCM 토큰이 있어야 푸시 알림을 보낼 수 있음
      const allTokens: string[] = [];
      
      for (const driverDoc of driversSnapshot.docs) {
        const driverId = driverDoc.id;
        console.log(`🔍 드라이버 ${driverId}의 FCM 토큰 조회 중...`);
        
        // 해당 드라이버의 모든 FCM 토큰 가져오기 (여러 디바이스 대응)
        const tokensSnapshot = await db
          .collection('users')
          .doc(driverId)
          .collection('fcmTokens')
          .get();

        if (tokensSnapshot.empty) {
          console.warn(`⚠️ 드라이버 ${driverId}의 FCM 토큰이 없습니다`);
          continue;
        }

        tokensSnapshot.docs.forEach(tokenDoc => {
          const token = tokenDoc.data().token as string;
          if (token) {
            allTokens.push(token);
            console.log(`✅ 토큰 추가 (드라이버 ${driverId}): ${token.substring(0, 20)}...`);
          }
        });
      }

      if (allTokens.length === 0) {
        console.warn('⚠️ 알림을 보낼 드라이버 토큰이 없습니다 (모든 드라이버가 FCM 토큰 미등록)');
        return;
      }

      // ✅ 체크 4: 알림 메시지 구성
      // rideType에 따라 한글 표시 변환
      const rideTypeKor = rideType === 'airport_to_school' 
        ? '공항 → 학교' 
        : '학교 → 공항';
      
      // 출발 시간 포맷팅 (있는 경우)
      let departureTime = '미정';
      if (afterData.departureAt) {
        try {
          const date = afterData.departureAt.toDate();
          departureTime = new Intl.DateTimeFormat('ko-KR', {
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
          }).format(date);
        } catch (e) {
          console.warn('출발 시간 파싱 실패:', e);
        }
      }

      // ✅ 체크 5: FCM 메시지 페이로드 구성
      const payload: admin.messaging.MulticastMessage = {
        tokens: allTokens,
        notification: {
          title: '🚗 새로운 라이드 요청',
          body: `${rideTypeKor} | ${afterData.fromName || '출발'} → ${afterData.toName || '도착'} | 인원: ${afterData.peopleCount || afterData.members?.length || 1}명`,
        },
        // data: 알림을 탭했을 때 앱에서 사용할 데이터
        data: {
          type: 'ride_request',
          rideType: rideType,
          rideId: rideId,
          fromName: afterData.fromName || '',
          toName: afterData.toName || '',
          fromAddress: afterData.fromAddress || '',
          toAddress: afterData.toAddress || '',
          departureTime: departureTime,
          peopleCount: String(afterData.peopleCount || afterData.members?.length || 1),
        },
        // iOS용 추가 설정
        apns: {
          payload: {
            aps: {
              sound: 'default',  // 알림음 재생
              badge: 1,          // 뱃지 카운트
              category: 'RIDE_REQUEST',  // 알림 카테고리
            },
          },
        },
      };

      // ✅ 체크 6: 알림 전송
      console.log(`📨 ${allTokens.length}개의 토큰으로 알림 전송 중...`);
      const response = await messaging.sendEachForMulticast(payload);
      
      console.log('✅ [드라이버 알림] 라이드 요청 알림 전송 완료:', {
        totalTokens: allTokens.length,
        successCount: response.successCount,
        failureCount: response.failureCount,
        rideType,
        rideId,
      });

      // ✅ 체크 7: 실패한 토큰 로그 (토큰 정리는 하지 않음 - 일시적 실패일 수 있음)
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            console.error(`❌ 토큰 전송 실패 [${idx}]:`, {
              token: allTokens[idx].substring(0, 20) + '...',
              error: resp.error?.code,
              message: resp.error?.message,
            });
          }
        });
      }

    } catch (error) {
      console.error('❌ [드라이버 알림] onNewRideRequest 에러:', error);
    }
  }
);
