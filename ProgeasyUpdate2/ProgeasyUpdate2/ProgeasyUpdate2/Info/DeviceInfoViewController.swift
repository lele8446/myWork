import UIKit
import Cartography

class DeviceInfoViewController: CJViewController, UITableViewDataSource, UITableViewDelegate {
    
    var observer: NSObjectProtocol?
    var languageChangeObserver: NSObjectProtocol?
    
    private let titleLabel = UILabel()
    var backView: UIImageView = UIImageView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    var tableView: UITableView?
    var footerView: UIView!

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        debugPrint("\(type(of: self)) deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        view.backgroundColor = UIColor.white
        self.hbd_barAlpha = 0
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { notification in
            self.updateInfo()
        }
        languageChangeObserver = NotificationCenter.default.addObserver(forName: .languageChangeNotification, object: nil, queue: .main) { _ in
            self.loadDataFromSetting()
        }
        
        setupLayout()
        loadDataFromSetting()
        updateInfo()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadDataFromSetting() {
        self.title = LocalizedStr("Info")
        self.titleLabel.text = self.title
        updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupLayout() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        self.navigationItem.titleView = titleLabel
        
        backView.image = UIImage(named: "scan_back_view")
        view.addSubview(backView)
        constrain(backView, view) { backView, view in
            backView.top == view.top - navStatusHeight
            backView.bottom == view.bottom
            backView.left == view.left
            backView.right == view.right
        }
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        tableView!.separatorInset = .zero
        tableView!.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView!.backgroundColor = UIColor.clear
        tableView!.contentInsetAdjustmentBehavior = .never
        tableView!.sectionHeaderHeight = UITableView.automaticDimension
        tableView!.estimatedSectionHeaderHeight = 0.01
        tableView!.sectionHeaderHeight = 0.01
        tableView!.estimatedSectionFooterHeight = 0.01
        tableView!.sectionFooterHeight = 0.01
        tableView!.estimatedRowHeight = 100.0
        tableView!.rowHeight = UITableView.automaticDimension
        tableView!.separatorStyle = .none
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.register(DeviceInfoCell.self, forCellReuseIdentifier: "DeviceInfoCell")
        
        view.addSubview(tableView!)
        constrain(view, tableView!) { (view, tableView) in
            tableView.top == view.top + 0
            tableView.left == view.left
            tableView.right == view.right
            tableView.bottom == view.bottom
        }
        
    }

    private func updateInfo() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "DeviceInfoCell", for: indexPath) as! DeviceInfoCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class InfoCardView: UIView {
    private let titleLabel = UILabel()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let tipView = TipView()

    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 16
        layer.masksToBounds = true

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        mainLabel.font = .systemFont(ofSize: 14)
        mainLabel.textColor = .label

        subLabel.font = .systemFont(ofSize: 12)
        subLabel.textColor = .secondaryLabel

        progressView.trackTintColor = UIColor.systemGray4
        progressView.progressTintColor = UIColor.colorFromRGB16(rbgValue: 0xAF52DE, alpha: 1)
        progressView.layer.cornerRadius = 6
        progressView.clipsToBounds = true

        let vStack = UIStackView(arrangedSubviews: [titleLabel, mainLabel, subLabel, progressView, tipView])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 12),
//            tipView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    func setProgressColor(color: UIColor) {
        progressView.progressTintColor = color
        tipView.view1.backgroundColor = color
    }
    
    func update(progress: CGFloat, mainText: String, subText: String, title: String) {
        progressView.progress = Float(progress)
        mainLabel.text = mainText
        subLabel.text = subText
        titleLabel.text = title
        tipView.label1.text = LocalizedStr("Used")
        tipView.label2.text = LocalizedStr("Available")
    }
    
    class TipView: UIView {
        let view1 = UIView()
        let label1 = UILabel()
        private let view2 = UIView()
        let label2 = UILabel()
        let viewHeight = 10.0
        init() {
            super.init(frame: .zero)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            self.backgroundColor = .clear
            setupView(view: view1)
            NSLayoutConstraint.activate([
                view1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view1.widthAnchor.constraint(equalToConstant: viewHeight),
                view1.heightAnchor.constraint(equalToConstant: viewHeight),
                view1.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            label1.text = LocalizedStr("Used")
            setupLabel(label: label1)
            NSLayoutConstraint.activate([
                label1.leadingAnchor.constraint(equalTo: self.view1.trailingAnchor, constant: 2),
                label1.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
                label1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            ])
            setupView(view: view2)
            view2.backgroundColor = UIColor.systemGray4
            NSLayoutConstraint.activate([
                view2.leadingAnchor.constraint(equalTo: self.label1.trailingAnchor, constant: 10),
                view2.widthAnchor.constraint(equalToConstant: viewHeight),
                view2.heightAnchor.constraint(equalToConstant: viewHeight),
                view2.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            label2.text = LocalizedStr("Available")
            setupLabel(label: label2)
            NSLayoutConstraint.activate([
                label2.leadingAnchor.constraint(equalTo: self.view2.trailingAnchor, constant: 2),
                label2.topAnchor.constraint(equalTo: self.topAnchor),
                label2.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                label2.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 0),
            ])

        }
        private func setupView(view: UIView) {
            view.backgroundColor = UIColor.colorFromRGB16(rbgValue: 0xAF52DE, alpha: 1)
            view.layer.cornerRadius = viewHeight/2.0
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        private func setupLabel(label: UILabel) {
            label.font = UIFont.systemFont(ofSize: 11)
            label.textColor = UIColor.subtitle_88
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
        }
    }
}
class DeviceInfoCell: UITableViewCell {
    var backView: InfoCardView = InfoCardView(title: "")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        contentView.addSubview(backView)
        constrain(contentView, backView) { (view, bView) in
            bView.top == view.top + 20
            bView.bottom == view.bottom - 0
            bView.left == view.left + 16
            bView.right == view.right - 16
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func update(progress: CGFloat, mainText: String, subText: String, title: String) {
        backView.update(progress: progress, mainText: mainText, subText: subText, title: title)
    }
}
