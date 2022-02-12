# Snack
![Swift](https://img.shields.io/badge/swift-v5.5.2-orange?logo=swift) ![Xcode](https://img.shields.io/badge/xcode-v13.1-blue?logo=xcode) 
</br>

## 💬 About Project
Node.js로 서버를 구축하고 Amazon RDS로 MySQL을 운영하고 있는 iOS 앱입니다.<br/>
<br/>
<br/>

## 📱 ScreenShots
<Blockquote>
실제 앱 구동화면입니다
</Blockquote>

| ![register](./image/register.gif) | ![generalLogin](./image/userLogin.gif) | ![adminLogin](./image/admin.gif) | ![autoLogin](./image/autoLogin.gif) |
| :-: | :-: | :-: | :-: |
| 회원가입 페이지 | 일반유저 로그인 | 관리자 로그인 | 자동 로그인 |
| ![blockedLogin](./image/blockedUser.gif) | ![personalMemo](./image/addMemo.gif) | ![accountEditing](./image/editAccount.gif) | ![gesture](./image/tapGesture.gif) |
| 차단유저 로그인  | 개인 메모 작성 | 개인정보 수정 | 탭제스처 인식 |
<br/>

## 🏃‍♀️ Installation
> 테스트 run을 위해서 해당 정보가 필요하신 경우 말씀해주시면 제공해드리겠습니다.
1. Server 폴더에 아래 사항들을 포함한 `.env` 파일을 추가해주세요.
```
PORT=3306
dbHost='database-1.clcnthr2is4n.ap-northeast-2.rds.amazonaws.com'
dbUser='admin'
dbPassword='admin123'
dbName='PersonalProject'
emailId='sgssgmanager@gmail.com'
emailPw='streamingsgs!'
jwtSecret='Kn8tO1Q4zPpw9vFUsatjPKb8mGuo8H/uM/9nGOMmKQjXG+ZGbK1Tuk/FuLULr+WJ6VeAAXI3GruLi6S+'
```
2. Server 폴더로 이동하신 후 필요한 모듈을 설치해주세요. 필요한 모듈을 포함한 코드는 아래와 같습니다.
```
npm install mysql express env-cmd bcryptjs jsonwebtoken nodemon dotenv --save
```
3. `npm start`를 실행하시면 서버를 시작하실 수 있습니다
4. iOS 폴더로 이동하셔서 `StoveDevCamp_PersonalProject.xcodeproj` 파일을 열어주시고, 시뮬레이터를 선택하신 후 run(`command + r`)하시면 앱을 사용하실 수 있습니다
```
<테스트 계정 정보>
1) 일반 유저
  id: test@gmail.com
  pw: aaa123
2) 차단된 유저
  id: block@gmail.com
  pw: aaa123
3) 어드민 유저
  id: admin
  pw: admin
```
<br/>

## 🌟 Features
###  1) 이메일 인증을 통한 회원가입
- SMTP를 사용하여 이메일 인증 구현

###  2) 보다 안전한 토큰 기반 인증
- Refresh Token과 AccessToken를 둘다 이용하여서 보안 강화

###  3) 자동로그인
- SwiftKeychainWrapper와 UserDefaults를 사용해서 자동로그인 구현

###  4) 애니메이션 요소
- Lottie와 CGAffineTransform를 이용하여서 디테일한 애니메이션 추가

###  5) User Interactive 요소 가미
- 유저의 long press와 tap 동작에 상호작용적으로 반응하는 UX 요소 추가
<br/>

## 🛠 Architecture
### 1) 전체 아키텍처
> 모

![Architecture](./image/architecture.png)

### 2) iOS 구조
> MVVM 패턴을 채택하였습니다. 화면 간 연결은 아래와 같이 구성되었습니다.

![iOS_Structure](./image/iOS_Structure.png)
<br/>

## 🔥 Technical Achievements
### 서버 사이드


### iOS 사이드
- r
