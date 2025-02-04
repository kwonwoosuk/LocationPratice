# 📱 LocationPractice
> MapKit과 CoreLocation을 활용한 위치 기반 날씨 정보 앱 + 사진 선택 및 표시기능 구현 연습

## 💫 주요 기능
- 현재 위치기반 지도 표시
- 위치 정보 권한 관리
- 위치 기반 날씨정보 표시 (현재온도, 최저온도, 최고 온도, 습도, 풍속등)
- 갤러리 접근 권한 관리
- 갤러리 사진 선택 및 표시


## 🛠 기술 스택
- Swift 5.0
- UIKit
- CoreLocation
- Kingfisher
- SnapKit

## 🔍 기술 설명
위치 정보 접근권한 관리
갤러리 접근 권한 관리

사진 관리

PHPickerViewController로 갤러리 접근
UICollectionView로 선택된 사진 표시
Delegate 패턴으로 WeatherViewController와 PhotoViewController 간 이미지 데이터 전달

## 🚨 트러블슈팅
위치 권한 처리

문제: 위치 권한 거부 시 앱 크래시
해결: 권한 상태별 분기 처리 및 기본 위치 설정
