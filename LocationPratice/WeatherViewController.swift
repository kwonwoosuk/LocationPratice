//
//  WeatherViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/3/25.
//

import UIKit
import CoreLocation
import SnapKit
import MapKit

protocol PhotoViewControllerDelegate { //fiveweek PassDataDelegate
    func imageReceived(_ vc: PhotoViewController, image: UIImage)
}


final class WeatherViewController: UIViewController {
    //latitude: 37.65370, longitude: 127.04740
    //현재온도, 최저온도, 최고온도, 습도, 풍속
    
    
    lazy var locationManager = CLLocationManager()
    
    let imageView = UIImageView()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "날씨 정보를 불러오는 중..."
        label.textColor = .black
        return label
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        refreshButtonTapped()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [mapView,
         weatherInfoLabel,
         imageView,
         currentLocationButton,
         refreshButton,
         photoButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(weatherInfoLabel.snp.trailing).offset(20)
            make.height.equalTo(120)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        photoButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(50)
        }
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        locationManager.delegate = self
    }
    
    
    @objc // delegate
    func photoButtonTapped() {
        let vc = PhotoViewController()
        vc.delegate = self // -> WeatherViewController 집어넣는 것 
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Actions
    // 현재 위치
    @objc private func currentLocationButtonTapped(center: CLLocationCoordinate2D) {
        checkDeviceLocation()
    }
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)
        
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        //어노 테이션의 좌표를 받아온 좌표로 ! 현위치거나 새싹도봉이거나
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
    }

    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        if let coordinate = locationManager.location?.coordinate {
            updateData(lat: coordinate.latitude, long: coordinate.longitude)
        } else {
            updateData(lat: 37.65370, long: 127.04740)
        }
    }
    
    private func updateData(lat: Double, long: Double) {
        NetworkManager.shared.getWeatherData(lat: lat, lon: long) { response in
            switch response {
            case .success(let success):
                self.weatherInfoLabel.text = """
                현재온도: \(success.main.temp)°C
                최저온도: \(success.main.temp_min)°C
                최고온도: \(success.main.temp_max)°C
                습도: \(success.main.humidity)%
                풍속: \(success.wind.speed)m/s
                """
            case .failure(let failure):
                print(failure)
                self.weatherInfoLabel.text = "날씨정보를 불러오지 못했습니다"
            }
        }
    }
    
    
    private func checkDeviceLocation() {
        DispatchQueue.global().async {
            // 시스템 권한 먼저 확인
            if CLLocationManager.locationServicesEnabled() {
                
                
                DispatchQueue.main.async {
                    self.checkCurrentAuthorizationStatus()
                }
                
                self.locationManager.requestWhenInUseAuthorization()
                
            } else {
                DispatchQueue.main.async {
                    print("위치 서비스가 꺼져 있어 위치권한을 요청할 수 없습니다 ")
                    
                }
            }
        }
    }
    
    // 현재 권한 상태 확인 사용자가 먼짓을 했을지 몰라
    func checkCurrentAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        let seedCube = CLLocationCoordinate2D(latitude: 37.65370, longitude: 127.04740)
        
        switch status {
        case .notDetermined:
            print("미결정상태")
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        case .denied:
            print("설정으로 가는 코드")
            let region = MKCoordinateRegion(center: seedCube, latitudinalMeters: 250, longitudinalMeters: 250)
            mapView.setRegion(region, animated: true)
            showLocationSettingsAlert()
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // gps 정보 가져와죠!
            
        default:
            let region = MKCoordinateRegion(center: seedCube, latitudinalMeters: 250, longitudinalMeters: 250)
            mapView.setRegion(region, animated: true)
            showLocationSettingsAlert()
        }
    }
    
    
}





extension  WeatherViewController: CLLocationManagerDelegate {
    //위치를 가져온경우 -> 허용
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    //위치를 가져오지 못한경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           let seedCube = CLLocationCoordinate2D(latitude: 37.65370, longitude: 127.04740)
           let region = MKCoordinateRegion(center: seedCube, latitudinalMeters: 250, longitudinalMeters: 250)
           mapView.setRegion(region, animated: true)
       }
    
    
    // iOS14+ 사용가능 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { //  다시한번! 권한상태가 변경될때 실행, locationManager 인스턴스가 생설될때 실행 ! -> viewdidload호출 불필요
        print(#function)
        checkDeviceLocation()
    }

    private func showLocationSettingsAlert() {
        let alert = UIAlertController(
            title: "위치 권한 필요",
            message: "위치 권한이 필요합니다. 기기의 '설정>개인정보 보호'에서 위치 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension WeatherViewController: PhotoViewControllerDelegate {
    func imageReceived(_ vc: PhotoViewController, image: UIImage) {
        imageView.image = image
        navigationController?.popViewController(animated: true)
    }
    
    
}
