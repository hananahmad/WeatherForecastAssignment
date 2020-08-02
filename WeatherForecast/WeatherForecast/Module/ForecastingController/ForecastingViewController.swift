//
//  ForecastingViewController.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 02/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//


import UIKit
import CoreLocation

class ForecastingViewController : UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var getCurrentWeatherBtn: UIButton! {
        didSet {
            getCurrentWeatherBtn.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
            getCurrentWeatherBtn.layer.shadowOpacity = 0.8
            getCurrentWeatherBtn.layer.borderWidth = 1.0
            getCurrentWeatherBtn.layer.borderColor = UIColor(red: 253.0 / 255.0, green: 97.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0).cgColor
            getCurrentWeatherBtn.layer.shadowRadius = 5.0
            getCurrentWeatherBtn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            getCurrentWeatherBtn.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var collectionView : UICollectionView!
    var forecastData: [ForecastTemperature] = []
    var cityName = ""
    
    //MARK:- ViewModel Instance
    lazy var viewModel: ForecastingViewModel = {
        return ForecastingViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Forecast for city: \(self.cityName)"
        
        self.configureCollectionView()
        
        // init view model
        initVM()
        
        addLocationIcon() // Add current location icon
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.collectionView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.collectionView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.initFetch(with: self.cityName)
        
    }
    
    func addLocationIcon() {
        //create a new button
        let button: UIButton = UIButton(type: .custom)
        //set image for button
        button.setImage(#imageLiteral(resourceName: "round_near_me_black_24pt"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(currentLocationTapped), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func currentLocationTapped() {
        LocationManager.shared.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            if error != nil {
                self.showAlert((error?.localizedDescription)!)
                return
            }
            guard let placemark = placemark else {
                return
            }
            
            self.title = placemark.locality ?? self.cityName
            self.cityName = placemark.locality ?? self.cityName
            self.viewModel.initFetch(with: self.cityName)
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
}

extension ForecastingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as? ForecastCell else {
            fatalError("Cell not exists")
        }
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.weatherListCellViewModel = cellVM
        
        return cell
    }
}
