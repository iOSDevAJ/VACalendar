import UIKit

// This is a fork library from ankit jain
// This is just to test fork


public protocol VAMonthHeaderViewDelegate: class {
    func didTapNextMonth()
    func didTapPreviousMonth()
}

public struct VAMonthHeaderViewAppearance {
    
    let monthFont: UIFont
    let monthTextColor: UIColor
    let monthTextWidth: CGFloat
    let previousButtonImage: UIImage
    let nextButtonImage: UIImage
    let dateFormatter: DateFormatter
    
    static public let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    public init(
        monthFont: UIFont = UIFont.systemFont(ofSize: 16),
        monthTextColor: UIColor = UIColor.white,
        monthTextWidth: CGFloat = 150,
        previousButtonImage: UIImage = UIImage(),
        nextButtonImage: UIImage = UIImage(),
        dateFormatter: DateFormatter = VAMonthHeaderViewAppearance.defaultFormatter) {
        self.monthFont = monthFont
        self.monthTextColor = monthTextColor
        self.monthTextWidth = monthTextWidth
        self.previousButtonImage = previousButtonImage
        self.nextButtonImage = nextButtonImage
        self.dateFormatter = dateFormatter
    }
    
}

public class VAMonthHeaderView: UIView {
    
    public var appearance = VAMonthHeaderViewAppearance() {
        didSet {
            dateFormatter = appearance.dateFormatter
            setupView()
        }
    }
    
    public weak var delegate: VAMonthHeaderViewDelegate?
    
    private var dateFormatter = DateFormatter()
    private let monthLabel = UILabel()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = 30
        monthLabel.frame = CGRect(x: 0, y: 0, width: appearance.monthTextWidth, height: frame.height)
        monthLabel.center.x = center.x - 25
//        previousButton.frame = CGRect(x: monthLabel.frame.minX - buttonWidth, y: 0, width: buttonWidth, height: frame.height)
//        nextButton.frame = CGRect(x: monthLabel.frame.maxX, y: 0, width: buttonWidth, height: frame.height)
        
        previousButton.frame = CGRect(x:  15, y: 5, width: 30, height: 30)
        nextButton.frame = CGRect(x: frame.size.width - 15 - 30 , y: 5, width: 30, height: 30)
        
        self.layer.cornerRadius = 8;
        self.clipsToBounds = true
        
    }
    
    private func setupView() {
        subviews.forEach{ $0.removeFromSuperview() }
        
      //  backgroundColor = .white
        monthLabel.font = appearance.monthFont
        monthLabel.textAlignment = .center
        monthLabel.textColor = appearance.monthTextColor
        
        previousButton.setImage(appearance.previousButtonImage, for: .normal)
        previousButton.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        
        nextButton.setImage(appearance.nextButtonImage, for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        print("month label",monthLabel)
        addSubview(monthLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        
        layoutSubviews()
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        delegate?.didTapNextMonth()
    }
    
    @objc
    private func didTapPrevious(_ sender: UIButton) {
        delegate?.didTapPreviousMonth()
    }
    
}

extension VAMonthHeaderView: VACalendarMonthDelegate {
    
    public func monthDidChange(_ currentMonth: Date) {
        monthLabel.text = dateFormatter.string(from: currentMonth)
    }
    
}

