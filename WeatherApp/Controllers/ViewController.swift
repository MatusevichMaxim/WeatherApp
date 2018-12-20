import UIKit
import PureLayout
import CoreLocation
import ForecastIO

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    let maxScaleFactor: Double = 0.5
    let sliderWidth: CGFloat = 1600
    let requiredHours: Int = 8
    
    var timelineScrollView: UIScrollView!
    var interactionBackground: UIImageView!
    var frontLayer: UIImageView!
    var interactionTimeline: UIView!
    var sliderPanel: UIView!
    var timelineCursor: UIView!
    var nextTipButtonArea: UIView!
    var dateTimeLabel: UILabel!
    var mainTemperatureLabel: UILabel!
    var temperatureSign: UILabel!
    var conditionLabel: UILabel!
    var tipLabel: UILabel!
    var locationManager = CLLocationManager()
    
    var additionalHour: Int = 0
    var timelineIntervalStartValue: CGFloat = 0
    var timelineCommonInterval: CGFloat?
    var coordinatesTaken: Bool = false
    var darkSkyClient: DarkSkyClient?
    var forecast: Forecast?
    var metadata: RequestMetadata?
    
    lazy var weatherManager = APIWeatherManager(apiKey: Constants.apiKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineCommonInterval = sliderWidth / CGFloat(requiredHours)
        enableLocationServices()
        
        darkSkyClient = DarkSkyClient(apiKey: Constants.apiKey)
        darkSkyClient!.language = .english
        darkSkyClient!.units = .us
        
        setupScrollContent()
        setupTip()
        toggleActivityIndicator(on: true)
    }
    
    func toggleActivityIndicator(on: Bool) {
        if (on) {
            // start animating
        } else {
            // stop animating
        }
    }
    
    func getCurrentWeatherData(coordinates: Coordinates) {
        darkSkyClient!.getForecast(latitude: coordinates.latitude, longitude: coordinates.longitude, completion: { (result) -> Void in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                self.forecast = currentForecast
                self.metadata = requestMetadata
                self.updateUIWith(currentWeather: currentForecast)
            case .failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        })
    }
    
    func updateUIWith(currentWeather: Forecast) {
        DispatchQueue.main.async {
            self.mainTemperatureLabel.text = String(Int(round((self.forecast?.currently?.temperature?.convertFromFahrenheitToCelsius)!)))
            self.conditionLabel.text = self.forecast?.currently?.summary
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupScrollContent() {
        // Setup for main scrollView //
        backgroundScrollView.delegate = self
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.isPagingEnabled = true
        
        let background = UIImage(named: "background")
        
        // front Layer
        frontLayer = UIImageView()
        frontLayer.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth * 2, height: Constants.screenHeight)
        frontLayer.image = background
        
        interactionBackground = UIImageView()
        backgroundScrollView.addSubview(interactionBackground)
        interactionBackground.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth * 2, height: Constants.screenHeight)
        interactionBackground.addSubview(frontLayer)
        
        frontLayer.autoPinEdgesToSuperviewEdges()
        
        // Timeline scrollView //
        timelineScrollView = UIScrollView(frame: CGRect(x: Constants.screenWidth, y: 0, width: Constants.screenWidth, height: Constants.screenHeight))
        timelineScrollView.delegate = self
        timelineScrollView.showsVerticalScrollIndicator = false
        timelineScrollView.showsHorizontalScrollIndicator = false
        
        let svbg = UIImage(named: "testBG")!
        interactionTimeline = UIView()
        interactionTimeline.alpha = 0
        timelineScrollView.addSubview(interactionTimeline)
        interactionTimeline.frame = CGRect(x: 0, y: 0, width: sliderWidth, height: Constants.screenHeight)
        interactionTimeline.backgroundColor = UIColor(patternImage: svbg)
        
        backgroundScrollView.addSubview(timelineScrollView)
        
        dateTimeLabel = UILabel()
        dateTimeLabel.font = UIFont(name: "Geomanist-Regular", size: 18)
        dateTimeLabel.text = DateManager.getDate()
        dateTimeLabel.textColor = .white
        dateTimeLabel.numberOfLines = 1
        dateTimeLabel.sizeToFit()
        interactionBackground.addSubview(dateTimeLabel)
        
        dateTimeLabel.autoPinEdge(.top, to: .top, of: interactionBackground, withOffset: UIDevice.getGeneration() == .XGeneration ? 88 : 56)
        dateTimeLabel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        dateTimeLabel.autoPinEdge(.right, to: .right, of: interactionBackground, withOffset: -30)
        
        setupTimeSlider()
        
        mainTemperatureLabel = UILabel()
        mainTemperatureLabel.font = UIFont(name: "Geomanist-Bold", size: 80)
        mainTemperatureLabel.textColor = .white
        mainTemperatureLabel.textAlignment = .left
        mainTemperatureLabel.numberOfLines = 1
        interactionBackground.addSubview(mainTemperatureLabel)
        
        temperatureSign = UILabel()
        temperatureSign.font = UIFont(name: "Geomanist-Bold", size: 30)
        temperatureSign.text = "o"
        temperatureSign.textColor = .white
        temperatureSign.textAlignment = .natural
        temperatureSign.numberOfLines = 1
        temperatureSign.sizeToFit()
//        interactionBackground.addSubview(temperatureSign)
        
        conditionLabel = UILabel()
        conditionLabel.font = UIFont(name: "Geomanist-Regular", size: 16)
        conditionLabel.textColor = .white
        conditionLabel.textAlignment = .right
        conditionLabel.numberOfLines = 2
        interactionBackground.addSubview(conditionLabel)
        
        mainTemperatureLabel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        mainTemperatureLabel.autoPinEdge(.top, to: .bottom, of: sliderPanel, withOffset: 40)
        mainTemperatureLabel.autoPinEdge(.right, to: .right, of: interactionBackground, withOffset: -Constants.screenWidth / 2)
        
//        temperatureSign.autoPinEdge(.left, to: .right, of: mainTemperatureLabel, withOffset: 7)
//        temperatureSign.autoPinEdge(.top, to: .top, of: mainTemperatureLabel, withOffset: -4)
        
        conditionLabel.autoPinEdge(.bottom, to: .bottom, of: mainTemperatureLabel, withOffset: -16)
        conditionLabel.autoPinEdge(.right, to: .right, of: interactionBackground, withOffset: -30)
        conditionLabel.autoPinEdge(.left, to: .right, of: interactionBackground, withOffset: -Constants.screenWidth / 2)
    }
    
    override func viewDidLayoutSubviews() {
        backgroundScrollView.contentSize = interactionBackground.frame.size
        backgroundScrollView.setContentOffset(CGPoint(x: Constants.screenWidth, y: 0), animated: false)
        timelineScrollView.contentSize = interactionTimeline.frame.size
    }
    
    func setupTimeSlider() {
        sliderPanel = UIView()
        sliderPanel.backgroundColor = .black
        sliderPanel.alpha = 0.1
        
        timelineCursor = UIView()
        timelineCursor.backgroundColor = .white
        timelineCursor.layer.cornerRadius = 1.5
        
        interactionBackground.addSubview(sliderPanel)
        interactionBackground.addSubview(timelineCursor)
        
        sliderPanel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        sliderPanel.autoPinEdge(.top, to: .bottom, of: dateTimeLabel, withOffset: 24)
        sliderPanel.autoPinEdge(toSuperviewEdge: .right)
        sliderPanel.autoSetDimension(.height, toSize: 1)
        
        timelineCursor.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        timelineCursor.autoPinEdge(.top, to: .top, of: sliderPanel, withOffset: -1)
        timelineCursor.autoSetDimensions(to: CGSize(width: 90, height: 3))
    }
    
    func setupTip() {
        nextTipButtonArea = UIView()
        nextTipButtonArea.sizeToFit()
        interactionBackground.addSubview(nextTipButtonArea)
        nextTipButtonArea.autoPinEdge(.right, to: .right, of: interactionBackground, withOffset: -30)
        nextTipButtonArea.autoPinEdge(.bottom, to: .bottom, of: interactionBackground, withOffset: UIDevice.getGeneration() == .XGeneration ? -48 : -30)
        
        let nextTipArrow = UIImageView(image: UIImage(named: "rightArrow")!)
        nextTipArrow.sizeToFit()
        nextTipButtonArea.addSubview(nextTipArrow)
        
        nextTipArrow.autoPinEdge(.right, to: .right, of: nextTipButtonArea)
        nextTipArrow.autoPinEdge(.bottom, to: .bottom, of: nextTipButtonArea)
        
        let nextTipLabel = UILabel()
        nextTipLabel.font = UIFont(name: "Geomanist-Regular", size: 16)
        nextTipLabel.text = NSLocalizedString("next_tips", comment: "")
        nextTipLabel.textColor = .white
        nextTipLabel.numberOfLines = 1
        nextTipLabel.sizeToFit()
        nextTipButtonArea.addSubview(nextTipLabel)
        
        nextTipLabel.autoPinEdge(.right, to: .left, of: nextTipArrow, withOffset: -33)
        nextTipLabel.autoPinEdge(.bottom, to: .bottom, of: nextTipButtonArea)
        
        tipLabel = UILabel()
        tipLabel.textColor = .white
        tipLabel.numberOfLines = 4
        tipLabel.sizeToFit()
        interactionBackground.addSubview(tipLabel)
        
        let title = NSLocalizedString("little_tip", comment: "")
        let description = NSLocalizedString("grab_u_umbrella", comment: "")
        let stringLabelText = "\(title)\n\(description)"
        let attributedString = NSMutableAttributedString(string: stringLabelText)
        let titleParagraphStyle = NSMutableParagraphStyle()
        let labelParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineSpacing = 18
        labelParagraphStyle.lineSpacing = 10
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: labelParagraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleParagraphStyle, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Geomanist-Regular", size: 16)!, range: (stringLabelText as NSString).range(of: title))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Geomanist-Bold", size: 32)!, range: (stringLabelText as NSString).range(of: description))
        tipLabel.attributedText = attributedString
        
        tipLabel.autoPinEdge(.bottom, to: .top, of: nextTipButtonArea, withOffset: -91)
        tipLabel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        tipLabel.autoPinEdge(.right, to: .right, of: interactionBackground, withOffset: -50)
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard coordinatesTaken else {
            if let location = locations.first {
                locationManager.stopUpdatingLocation()
                coordinatesTaken = true
                print("Found user's location: \(location)")
                let locValue: CLLocationCoordinate2D = manager.location!.coordinate
                let coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
                getCurrentWeatherData(coordinates: coordinates)
            }
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func getTime(needIncValue: Bool) {
        if needIncValue {
            timelineIntervalStartValue += timelineCommonInterval!
            additionalHour += 1
        }
        else {
            timelineIntervalStartValue -= timelineCommonInterval!
            additionalHour -= 1
        }
        dateTimeLabel.text = DateManager.getDate(adjHours: additionalHour)
        
        mainTemperatureLabel.text = additionalHour == 0 ? String(Int(round((forecast?.currently?.temperature?.convertFromFahrenheitToCelsius)!))) : String(Int(round((forecast?.hourly?.data[additionalHour].temperature?.convertFromFahrenheitToCelsius)!)))
        conditionLabel.text = additionalHour == 0 ? forecast?.currently?.summary : forecast?.hourly?.data[additionalHour].summary
    }
}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == backgroundScrollView && scrollView.contentOffset.x < UIScreen.main.bounds.width {
            // parallax layers
            let oppositeOffset = (Constants.screenWidth - scrollView.contentOffset.x).magnitude
            let scaleOffset = CGFloat(maxScaleFactor / 100 * Double(oppositeOffset / (Constants.screenWidth / 100)))
            
            frontLayer.transform = CGAffineTransform(scaleX: 1 + scaleOffset, y: 1 + scaleOffset)
        }
        
        if scrollView == timelineScrollView {
            // cursor |       ---=======-----------------|
            let newCursorLocation = CGPoint(x: (UIScreen.main.bounds.width + 50) + scrollView.contentOffset.x * (sliderPanel.frame.width / sliderWidth), y: timelineCursor.frame.origin.y)
            timelineCursor.frame = CGRect(origin: newCursorLocation, size: timelineCursor.frame.size)
            
            if scrollView.contentOffset.x < timelineIntervalStartValue && timelineIntervalStartValue != 0 {
                getTime(needIncValue: false)
            }
            
            if scrollView.contentOffset.x > timelineIntervalStartValue + timelineCommonInterval! {
                getTime(needIncValue: true)
            }
        }
    }
}

