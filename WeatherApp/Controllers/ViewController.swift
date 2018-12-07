import UIKit
import PureLayout

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var mainTemperature: UILabel!
    @IBOutlet weak var centerLineConstraint: NSLayoutConstraint!
    
    var interactionBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollContent()
    }
    
    private func setupScrollContent() {
        backgroundScrollView.delegate = self
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.showsHorizontalScrollIndicator = false
        
        let background = UIImage(named: "background")!
        interactionBackground = UIImageView()
        backgroundScrollView.addSubview(interactionBackground)
        interactionBackground.frame = CGRect(x: 0, y: 0, width: 1012, height: 750)
        interactionBackground.image = background
    }
    
    override func viewDidLayoutSubviews() {
        backgroundScrollView.contentSize = interactionBackground.frame.size
        backgroundScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < UIScreen.main.bounds.width && backgroundScrollView.subviews.count == 0 {
            
        }
    }
}

