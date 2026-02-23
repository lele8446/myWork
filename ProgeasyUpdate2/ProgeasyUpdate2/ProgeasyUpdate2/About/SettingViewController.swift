//
//  SettingViewController.swift
//  CJMetro
//
//  Created by C.K.Lian on 2024/4/13.
//

import Foundation
import Cartography

extension Notification.Name {
    static let languageChangeNotification = Notification.Name("CJLanguageChangeNotic")
}

class TabViewSettingCell: UITableViewCell {
    var backView: UIView = UIView()
    var titleLabel: UILabel = UILabel()
    var decLabel: UILabel = UILabel()
    var redPoint: UIView = UIView()
    var rightIcon: UIImageView = UIImageView()
    var line: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(backView)
        constrain(contentView, backView) { (view, bView) in
            bView.top == view.top + 16
            bView.bottom == view.bottom - 16
            bView.left == view.left
            bView.right == view.right
        }
        
        let image = UIImage(named: "common_ic_access")
        rightIcon = UIImageView(image: image)
        backView.addSubview(rightIcon)
        constrain(backView, rightIcon) { (view, settingBtn) in
            settingBtn.width == 12
            settingBtn.height == 12
            settingBtn.right == view.right - 16
            settingBtn.centerY == view.centerY
        }
        backView.addSubview(redPoint)
        redPoint.clipsToBounds = true
        redPoint.isHidden = true
        redPoint.layer.cornerRadius = 4
        redPoint.backgroundColor = UIColor.red
        constrain(backView, rightIcon, redPoint) { (view, rightIcon, redPoint) in
            redPoint.centerY == view.centerY
            redPoint.width == 8
            redPoint.height == 8
            redPoint.right == rightIcon.left - 6
        }
        
        decLabel.numberOfLines = 0
        //表示一个控件抗被拉伸的优先级，优先级越高，越不容易被拉伸，默认是251
        decLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        decLabel.font = UIFont.systemFont(ofSize: 15)
        decLabel.textAlignment = .right
        decLabel.textColor = UIColor.explain_99
        backView.addSubview(decLabel)
        constrain(backView, rightIcon, decLabel) { (view, rightIcon, titleLabel) in
            titleLabel.top == view.top
            titleLabel.bottom == view.bottom
//            titleLabel.width == 100
            titleLabel.right == rightIcon.left - 5
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.title_33
        backView.addSubview(titleLabel)
        constrain(backView, decLabel, titleLabel) { (view, decLabel, titleLabel) in
            titleLabel.top == view.top
            titleLabel.bottom == view.bottom
            titleLabel.left == view.left + 16
            titleLabel.right == decLabel.left - 10
        }

        line.backgroundColor = UIColor.separator_E8
        contentView.addSubview(line)
        constrain(contentView, line) { (view, line) in
            line.height == 1
            line.left == view.left+16
            line.right == view.right-16
            line.bottom == view.bottom
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingViewController: CJViewController, UITableViewDataSource, UITableViewDelegate {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray != nil) ? self.dataArray!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataArray![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabViewSettingCell", for: indexPath) as! TabViewSettingCell
        cell.selectionStyle = .none
        cell.titleLabel.text = item
        cell.redPoint.isHidden = true
        cell.decLabel.text = ""
//        cell.line.isHidden = indexPath.section == self.dataArray.count-1
        cell.decLabel.textColor = UIColor.explain_99
        if item == LocalizedStr("Language Settings") {//"Language Settings"
            cell.decLabel.textColor = UIColor.logo_color
            cell.decLabel.text = languageNameOptions[languageCode]
        }
        else if item == LocalizedStr("Check For Updates") {//"Check For Updates"
            cell.redPoint.isHidden = !newVersion
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = self.dataArray![indexPath.row]
        if item == LocalizedStr("Language Settings") {//"Language Settings"
            var options: [CJSheetOption] = []
            var index = -1;
            let array = languageNameOptions.keys
            let sortedArray = array.sorted { $0.lowercased() < $1.lowercased() }
            for (ind, item) in sortedArray.enumerated() {
                let code: String = item as String
                if code == languageCode {
                    index = ind
                }
                let option = CJSheetOption(text: languageNameOptions[code]!, parameter: code)
                options.append(option)
            }
            CJSheetView.show(title:dataArray![row], options: options, selectedIndex: index, completion:{ index, str in
                let option = options[index]
                // 切换语言
                DAConfig.languageChange {
                    NotificationCenter.default.post(name: .languageChangeNotification, object:nil)
                }
                DAConfig.setLanguageCode(option.parameter)
                self.languageCode = option.parameter
                self.loadData()
            })
        }
        else if item == LocalizedStr("Check For Updates") {//"Check For Updates"
            // TODO: 检测新版本
        }
        else if item == LocalizedStr("App Rating") {//"App Rating"
            let url = URL(string: "https://itunes.apple.com/app/\(appId)?action=write-review")
            if(url != nil){
                UIApplication.shared.open(url!)
            }else{
                CJHUD.cj_showMessage(LocalizedStr("Operation error."))
            }
//            CJCommonHelper.gotoRateUs()
        }
        else if item == LocalizedStr("Privacy Policy") {//"Privacy Policy":
//            let url = "https://ghjoa.oss-cn-shenzhen.aliyuncs.com/CJPic/CJPic_En1.html"
            var url =
                  "https://raw.githubusercontent.com/lele8446/CJPic/main/CJPrivacyPolicy/CJPic_En0.html"
            if (languageCode == "zh-Hans") {
              url =
                  "https://raw.githubusercontent.com/lele8446/CJPic/main/CJPrivacyPolicy/CJPic_Hans0.html"
            } else if (languageCode == "zh-Hant") {
              url =
                  "https://raw.githubusercontent.com/lele8446/CJPic/main/CJPrivacyPolicy/CJPic_Hant0.html"
            }
            
            let vc = CJWebViewController(myTitle: dataArray![row], url: url, rawData: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if item == LocalizedStr("Terms Of Service") {//"Terms Of Service":
//            let url = "https://ghjoa.oss-cn-shenzhen.aliyuncs.com/CJPic/Terms.html"
            let url =
                  "https://raw.githubusercontent.com/lele8446/CJPic/main/CJPrivacyPolicy/Terms.html"
            let vc = CJWebViewController(myTitle: dataArray![row], url: url, rawData: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if item == LocalizedStr("Contact Us") {//"Contact Us":
            let vc = CJContactUsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadData() {
        self.title = LocalizedStr("About")
        dataArray = [
            LocalizedStr("Language Settings"),
            LocalizedStr("Check For Updates"),
            LocalizedStr("App Rating"),
            LocalizedStr("Privacy Policy"),
            LocalizedStr("Terms Of Service"),
            LocalizedStr("Contact Us"),
        ]
        tableView!.reloadData()
        // TODO：检测新版本
        updateAppName()
    }
    
    var topView: UIView?
    var decLabel: UILabel!
    var tableView: UITableView?
    var footerView: UIView!
    var dataArray:[String]?
    var languageCode : String = "en"
    var newVersion: Bool = false
    var link = "itms-apps://itunes.apple.com/app/id\(kAppId)"
    var appId = kAppId
    let languageNameOptions = [
        "en" : "English",
        "ar" : "العربية",
        "fr" : "Français",
        "de" : "Deutsch",
        "zh-Hans" : "中文 (简体)",
        "zh-Hant" : "中文 (繁體)",
        "ja" : "日本語",
        "ko" : "한국어",
        "ru" : "Русский",
        "es" : "Español",//西班牙
        "it" : "Italiano",
        "th" : "ไทย",
    ]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.view_color
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        var key = DAConfig.languageCode()
        if key != "zh-Hans" && key != "zh-Hant" {
            let str = key! as NSString
            let range = str.range(of: "-")
            if range.location != NSNotFound && range.length > 0 {
                key = str.substring(to: range.location)
            }
        }
        if key != nil && languageNameOptions[key!] != nil {
            self.languageCode = key!
        }else{
            self.languageCode = "en"
        }
        
        //初始化UITableView
        tableView = UITableView(frame: CGRect(), style: .plain)
        tableView!.separatorInset = .zero
        tableView!.backgroundColor = UIColor.view_color
        tableView!.contentInsetAdjustmentBehavior = .never
        tableView!.sectionHeaderHeight = 0.0
        tableView!.estimatedSectionHeaderHeight = 0.0
        tableView!.sectionFooterHeight = 0.0
        tableView!.estimatedRowHeight = 60.0
        tableView!.rowHeight = UITableView.automaticDimension
        tableView!.separatorStyle = .none
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.register(TabViewSettingCell.self, forCellReuseIdentifier: "TabViewSettingCell")
        self.view.addSubview(tableView!)
        constrain(view, tableView!) { (view, tableView) in
            tableView.top == view.top + navStatusHeight
            tableView.left == view.left
            tableView.right == view.right
            tableView.bottom == view.bottom
        }
        
        let top = (3 * 16.0)
        let logoHeight = 100.0
        topView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: (top + logoHeight + 14 + 50 + logoHeight-20)))
        
        let image = UIImage(named: "logo240")
        let logoView = UIImageView(image: image)
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 15
        topView!.addSubview(logoView)
        constrain(topView!, logoView) { (view, logoView) in
            logoView.width == logoHeight
            logoView.height == logoHeight
            logoView.top == view.top + top
            logoView.centerX == view.centerX
        }
        
        decLabel = UILabel()
        decLabel.numberOfLines = 0
        decLabel.font = UIFont.systemFont(ofSize: 17)
        decLabel.textAlignment = .center
        decLabel.textColor = UIColor.explain_99
        
        topView!.addSubview(decLabel)
        constrain(topView!, logoView, decLabel) { (view, logoView, titleLabel) in
            titleLabel.top == logoView.bottom + 14
            titleLabel.left == view.left
            titleLabel.right == view.right
            titleLabel.height == 50
        }
        let line = UIView()
        line.backgroundColor = UIColor.separator_E8
        topView!.addSubview(line)
        constrain(topView!, line) { (view, line) in
            line.height == 1
            line.left == view.left+16
            line.right == view.right-16
            line.bottom == view.bottom
        }
        
        tableView!.tableHeaderView = topView!
        
        loadData()
        
    }
    
    private func updateAppName() {
        var nameStr = ""
        nameStr = kAppName()
        
        let info = Bundle.main.infoDictionary
        let str = info!["CFBundleShortVersionString"] ?? "1.0.0"
        let attStr = title(name: nameStr, version: "\nV \(str)")
        decLabel.attributedText = attStr
    }
    
    private func title(name: String, version: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        // 设置行间距
        let style = NSMutableParagraphStyle()
        // 间隙
        style.lineSpacing = 4
        style.alignment = .center
        let font = UIFont.systemFont(ofSize: 17)
        let fontAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.title_33,
            .font: font,
            .paragraphStyle: style
        ]
        
        let string = NSAttributedString(string: name, attributes: fontAttributes)
        attributedString.append(string)
        
        let font1 = UIFont.systemFont(ofSize: 15)
        let fontAttributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.explain_99,
            .font: font1,
            .paragraphStyle: style
        ]
        
        let string2 = NSAttributedString(string: version, attributes: fontAttributes1)
        attributedString.append(string2)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
         
        return attributedString
    }
    @objc func appDidBecomeActive() {
        
    }
}
