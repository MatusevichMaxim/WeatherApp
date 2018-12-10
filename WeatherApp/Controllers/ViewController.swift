import UIKit
import PureLayout

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    var timelineScrollView: UIScrollView!
    var interactionBackground: UIImageView!
    var interactionTimeline: UIView!
    var sliderPanel: UIView!
    var timelineCursor: UIView!
    var mainTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollContent()
    }
    
    private func setupScrollContent() {
        // Setup for main scrollView //
        backgroundScrollView.delegate = self
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.isPagingEnabled = true
        
        let background = UIImage(named: "background")
        interactionBackground = UIImageView()
        backgroundScrollView.addSubview(interactionBackground)
        interactionBackground.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth * 2, height: Constants.screenHeight - Constants.statusBarHeight)
        interactionBackground.image = background
        
        // Timeline scrollView //
        timelineScrollView = UIScrollView(frame: CGRect(x: Constants.screenWidth, y: 0, width: Constants.screenWidth, height: Constants.screenHeight))
        timelineScrollView.delegate = self
        timelineScrollView.showsVerticalScrollIndicator = false
        timelineScrollView.showsHorizontalScrollIndicator = false
        // if we need to lock bouncing
        //testSV.bounces = false
        
        let svbg = UIImage(named: "testBG")!
        interactionTimeline = UIView()
        interactionTimeline.alpha = 0
        timelineScrollView.addSubview(interactionTimeline)
        interactionTimeline.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth * 4, height: Constants.screenHeight)
        interactionTimeline.backgroundColor = UIColor(patternImage: svbg)
        
        backgroundScrollView.addSubview(timelineScrollView)
        
        setupTimeSlider()
        
        mainTemperatureLabel = UILabel()
        mainTemperatureLabel.font = mainTemperatureLabel.font.withSize(72)
        mainTemperatureLabel.text = "59°"
        mainTemperatureLabel.textColor = .white
        mainTemperatureLabel.textAlignment = .center
        interactionBackground.addSubview(mainTemperatureLabel)
        
        mainTemperatureLabel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        mainTemperatureLabel.autoPinEdge(.top, to: .bottom, of: sliderPanel, withOffset: 20)
        mainTemperatureLabel.autoSetDimensions(to: CGSize(width: 120, height: 100))
    }
    
    override func viewDidLayoutSubviews() {
        backgroundScrollView.contentSize = interactionBackground.frame.size
        backgroundScrollView.setContentOffset(CGPoint(x: Constants.screenWidth, y: 0), animated: false)
        timelineScrollView.contentSize = interactionTimeline.frame.size
    }
    
    func setupTimeSlider() {
        sliderPanel = UIView()
        sliderPanel.backgroundColor = .black
        sliderPanel.alpha = 0.2
        
        timelineCursor = UIView()
        timelineCursor.backgroundColor = .white
        
        interactionBackground.addSubview(sliderPanel)
        interactionBackground.addSubview(timelineCursor)
        
        sliderPanel.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        sliderPanel.autoPinEdge(.top, to: .top, of: interactionBackground, withOffset: 150)
        sliderPanel.autoPinEdge(toSuperviewEdge: .right)
        sliderPanel.autoSetDimension(.height, toSize: 3)
        
        timelineCursor.autoPinEdge(.left, to: .left, of: interactionBackground, withOffset: Constants.screenWidth + 50)
        timelineCursor.autoPinEdge(.top, to: .top, of: interactionBackground, withOffset: 150)
        timelineCursor.autoSetDimensions(to: CGSize(width: 90, height: 3))
    }
}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == backgroundScrollView && scrollView.contentOffset.x < UIScreen.main.bounds.width {
            // place for parallax
        }
        
        if scrollView == timelineScrollView {
            // cursor |       ---=======-----------------|
            let newCursorLocation = CGPoint(x: (UIScreen.main.bounds.width + 50) + scrollView.contentOffset.x * (sliderPanel.frame.width / 1500), y: timelineCursor.frame.origin.y)
            timelineCursor.frame = CGRect(origin: newCursorLocation, size: timelineCursor.frame.size)
        }
    }
}

