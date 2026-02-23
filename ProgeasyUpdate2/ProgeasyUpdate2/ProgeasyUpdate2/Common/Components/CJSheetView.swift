import UIKit
import Cartography


struct CJSheetOption {
    var text: String
    var parameter: String
}
typealias CompletionBlock = (Int, CJSheetOption) -> Void
class CJSheetView: UIViewController {
    var options: [CJSheetOption] = []
    var childViews: [UILabel] = []
    var selectedIndex: Int = 0
    var completion: CompletionBlock?
    var backgroundView: UIView?
    var bgView: UIView?
    var topView: UIView!
    var myTitle: String?
    
    private let cellHeight: CGFloat = 55.0
    private let sheetHeight: CGFloat = (bottomSafeArea() + 55.0 * CGFloat(4) + 60)
    private var scrollView: UIScrollView!
    var haveShow: Bool = false
    
    override func viewDidLayoutSubviews() {
        roundingCorners()
    }
    
    func roundingCorners (){
        // 创建圆角路径
        let cornerRadius: CGFloat = 12
        let maskPath = UIBezierPath(roundedRect: self.view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        // 创建CAShapeLayer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = maskPath.cgPath

        // 将CAShapeLayer设置为视图控制器的mask
        bgView!.layer.mask = maskLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background view with translucent effect
        backgroundView = UIView(frame: view.bounds)
        backgroundView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped)))
        view.addSubview(backgroundView!)
        constrain(view, backgroundView!) { (view, bView) in
            bView.top == view.top
            bView.bottom == view.bottom
            bView.left == view.left
            bView.right == view.right
        }

        
        bgView = UIView(frame: CGRect(x: 0, y: windowHeight, width: windowWidth, height: 0))
        bgView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
        bgView!.backgroundColor = UIColor.white
        backgroundView!.addSubview(bgView!)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        bgView!.addSubview(scrollView)
        constrain(bgView!, scrollView) { (view, bView) in
            bView.bottom == view.bottom - bottomSafeArea()
            bView.bottom == view.bottom
            bView.left == view.left
            bView.right == view.right
        }
        
        topView = UIView()
        bgView!.addSubview(topView)
        constrain(bgView!, scrollView, topView) { (view, scrollView, bView) in
            bView.top == view.top
            bView.bottom == scrollView.top
            bView.height == 60
            bView.left == view.left
            bView.right == view.right
        }
        var image = UIImage(named: "close")
        let close = btn(image: image!, action: #selector(cancelButtonTapped))
        topView.addSubview(close)
        constrain(topView, close) { (bView,close) in
            close.width == 30
            close.height == 30
            close.left == bView.left + 14
            close.centerY == bView.centerY
        }
        image = UIImage(named: "save")
        image = image?.cj_image(with: UIColor.logo_color)
        let save = btn(image: image!, action: #selector(saveButtonTapped))
        topView.addSubview(save)
        constrain(topView, save) { (bView,close) in
            close.width == 30
            close.height == 30
            close.right == bView.right - 14
            close.centerY == bView.centerY
        }
        let label = UILabel()
        label.text = myTitle
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.title_33
        topView.addSubview(label)
        constrain(topView, close, save, label) { (bView, close, save, label) in
            label.bottom == bView.bottom
            label.top == bView.top
            label.left == close.right + 16
            label.right == save.left - 16
        }
        let line = UIView()
        line.backgroundColor = UIColor.separator_E8
        topView.addSubview(line)
        constrain(topView, line) { (bView,line) in
            line.bottom == bView.bottom
            line.height == 1
            line.left == bView.left
            line.right == bView.right
        }
        
        addData()
        if(selectedIndex >= 0){
            let point = CGPoint(x: 0, y: selectedIndex * Int(cellHeight))
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func btn(image: UIImage, action: Selector) -> UIView {
        let bgView = UIView()
        let settingBtn = UIImageView(image: image)
        bgView.addSubview(settingBtn)
        constrain(bgView, settingBtn) { (view, settingBtn) in
            settingBtn.width == 22
            settingBtn.height == 22
            settingBtn.centerX == view.centerX
            settingBtn.centerY == view.centerY
        }
        let view = UIView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        let tapGesture0 = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture0)
        bgView.addSubview(view)
        constrain(bgView, settingBtn, view) { (backView, settingBtn, view) in
            view.top == backView.top
            view.left == backView.left
            view.right == backView.right
            view.bottom == backView.bottom
        }
        return bgView
    }
    
    func cell(index: Int, title: CJSheetOption, select: Bool) -> UILabel {
        let width = scrollView.frame.width - 0*2.0
        let view = UILabel(frame: CGRect(x: 0, y: CGFloat(index) * cellHeight, width: width, height: cellHeight))
        view.text = title.text
        view.font = UIFont.systemFont(ofSize: 15)
        view.textAlignment = .center
        view.backgroundColor = select ? UIColor.view_color : UIColor.white
        view.textColor = select ? UIColor.logo_color : UIColor.title_33
        view.tag = index
        view.isUserInteractionEnabled = true
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
        view.addGestureRecognizer(tapGesture0)
        let line = UIView(frame: CGRect(x: 10, y: cellHeight-0.75, width: width-20, height: 0.75))
        line.backgroundColor = UIColor.separator_E8.withAlphaComponent(0.75)
        view.addSubview(line)
        return view
    }
    
    func addData(){
        self.childViews.removeAll()
        scrollView.contentSize = CGSizeZero
        for (index, option) in options.enumerated() {
            let cell = cell(index: index, title: option, select: (selectedIndex == index))
            self.childViews.append(cell)
            scrollView.addSubview(cell)
        }
        scrollView.contentSize = CGSize(width: 0, height: CGFloat(options.count) * cellHeight)
    }
    
    func reloadData(){
        for (_, option) in childViews.enumerated() {
            let select = option.tag == selectedIndex
            option.backgroundColor = select ? UIColor.view_color : UIColor.white
            option.textColor = select ? UIColor.logo_color : UIColor.title_33
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!haveShow){
           showAnimated()
        }
    }
    
    @objc private func bgTapped() {}
    @objc private func cancelButtonTapped() {
        dismissAnimated()
    }
    
    @objc private func saveButtonTapped() {
        if(self.completion != nil){
            self.completion!(selectedIndex, options[selectedIndex])
        }
        dismissAnimated()
    }
    
    
    @objc private func optionTapped(_ recognizer:UITapGestureRecognizer) {
        let cell = recognizer.view
        selectedIndex = cell!.tag
        reloadData()
    }
    
    func showAnimated() {
        let height = sheetHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView!.frame = CGRect(x: 0, y: self.view.frameHeight-height, width: windowWidth, height: height)
        }) { (finished) in
            self.haveShow = true
        }
    }
    func dismissAnimated() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView!.frame = CGRect(x: 0, y: self.view.frameHeight, width: windowWidth, height: self.sheetHeight)
        }) { (finished) in
            self.haveShow = false
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    static func show(title: String, options: [CJSheetOption], selectedIndex: Int, completion: @escaping CompletionBlock) {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() else {
            return
        }
        
        let actionSheetVC = CJSheetView()
        actionSheetVC.options = options
        actionSheetVC.selectedIndex = selectedIndex
        actionSheetVC.completion = completion
        actionSheetVC.myTitle = title
        actionSheetVC.modalPresentationStyle = .overFullScreen
        topViewController.present(actionSheetVC, animated: false, completion: nil)
    }
}
