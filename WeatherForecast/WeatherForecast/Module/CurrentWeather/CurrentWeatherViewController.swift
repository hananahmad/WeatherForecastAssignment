//
//  CurrentWeatherViewController.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 31/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit

let SHADOW_GRAY: CGFloat = 120.0 / 255.0

class CurrentWeatherViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var getWeatherBtn: UIButton! {
        didSet {
            getWeatherBtn.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
            getWeatherBtn.layer.shadowOpacity = 0.8
            getWeatherBtn.layer.borderWidth = 1.0
            getWeatherBtn.layer.borderColor = UIColor(red: 253.0 / 255.0, green: 97.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0).cgColor
            getWeatherBtn.layer.shadowRadius = 5.0
            getWeatherBtn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            getWeatherBtn.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var inputCitiesTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- ViewModel Instance
    lazy var viewModel: CurrentWeatherViewModel = {
        return CurrentWeatherViewModel()
    }()
    
    var countForStrings = 0
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
    }
    
    func initView() {
        self.navigationItem.title = "Current Weather"
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        setWeatherButtonStates(state: false)
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
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func setWeatherButtonStates(state: Bool) {
        getWeatherBtn.isEnabled = state
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- UITableViewDelegate
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as? WeatherListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.weatherListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }
    
}

//MARK:- UITextFieldDelegate
extension CurrentWeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherAction(self.getWeatherBtn!)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(
            in: range,
            with: string).trimmed
        
        if string.isBackspace {
            if currentText.last == ","  {
                if countForStrings == 7 {
                    countForStrings = 6
                }
                countForStrings -= 1
            }
        }
        
        getWeatherBtn.isEnabled = prospectiveText.count > 0
        
        if string == "," {
            if countForStrings < 7 {
                countForStrings += 1
            }
        }
        
        if countForStrings < 7 {
            
        } else {
            if string == "," {
                return false
            }
        }
        
        return true
    }
}

//MARK:- Navigation
extension CurrentWeatherViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ForecastingViewController,
            let selectedCity = viewModel.selectedWeather?.name {
            vc.cityName = selectedCity
        }
    }
}

//MARK:- UITableViewCell
class WeatherListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var weatherListCellViewModel : WeatherListCellViewModel? {
        didSet {
            cityNameLbl.text = weatherListCellViewModel?.cityName
            nameLabel.text = weatherListCellViewModel?.temperatureText
            descriptionLabel.text = weatherListCellViewModel?.descText
            do {
                try mainImageView.downloadImage(url: weatherListCellViewModel?.weatherIcon ?? "", placeHolder: #imageLiteral(resourceName: "Sunny"))
            } catch (let error) {
                print(error.localizedDescription)
            }
            windLabel.text = weatherListCellViewModel?.windSpeed
        }
    }
}

//MARK:- IBAction
extension CurrentWeatherViewController {
    
    @IBAction func getWeatherAction(_ sender: Any) {
        
        self.inputCitiesTextField.resignFirstResponder()
        let trimmedString = self.inputCitiesTextField.text?.trimmed
        if trimmedString?.last == "," {
            self.inputCitiesTextField.text?.removeLast()
            self.countForStrings -= 1
        }
        
        var cities = self.inputCitiesTextField.text?.trimmed.trimmedCommas.components(separatedBy: ",") ?? []
        cities = cities.map({$0.trimmed})
        if cities.count < 3 {
            self.showAlert( "Please input atleast 3 cities with comma separation" )
        } else {
            viewModel.initFetch(with: cities)
        }
    }
}
