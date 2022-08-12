//
//  ViewController.swift
//  ClinicDemo
//
//  Created by Nivrutti on 12/08/22.
//

import UIKit


class ViewController: UIViewController {

// MARK: UI Elements outlet Declarations
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var chatButtonView: UIView!
    @IBOutlet weak var callButtonView: UIView!
    
    @IBOutlet weak var petNameLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint! //180
    
    
// MARK: Global Declarations
    
    var petModel: PetModel?
    var settingModel: SettingModel?
    
    
 // MARK: ViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        } else {
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.estimatedRowHeight = 100
        //tableView.rowHeight = UITableView.automaticDimension
        
        loadSettings()
        loadPetInfo()
    }
    
    
// MARK: Custom Methods
    
    func loadSettings() {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                settingModel = try JSONDecoder().decode(SettingModel.self, from: data)

                let workHours = settingModel?.settings.workHours
                let isCallEnabled = (settingModel?.settings.isCallEnabled ?? false) as Bool
                let isChatEnabled = (settingModel?.settings.isChatEnabled ?? false) as Bool
                
                if isChatEnabled == false && isCallEnabled == false {
                    buttonsView.isHidden = true
                    topViewHeight.constant = 80
                }
                
                if isChatEnabled == false {
                    chatButtonView.isHidden = true
                }
                
                if isCallEnabled == false {
                    callButtonView.isHidden = true
                }
                
                petNameLbl.text = workHours
            } catch {
                
            }
        }
    }
    
    func loadPetInfo()
    {
        if let path = Bundle.main.path(forResource: "pets", ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                petModel = try JSONDecoder().decode(PetModel.self, from: data)
            } catch {
                
            }
        }
    }
    
    @IBAction func chatOrCallButtonTapped(_ sender: UIButton) {
        
        let dayNumber = Date().dayNumberOfWeek()!
        if dayNumber == 1 || dayNumber == 7 {
            displyAlert(strTitle: "", strMessage: Constants.OUTSIDE_WORK_HOURS)
        } else {
            
            let workHours = settingModel?.settings.workHours

            let dataArray = workHours?.split(separator: " ", maxSplits: 5, omittingEmptySubsequences: true)
            
            if dataArray == nil {
                return
            }
            
            // Starting Work hours
            let first = dataArray![1]
            let strStart = String(first)
            let startTime = strStart.replacingOccurrences(of: ":", with: "")
            let startTimeInInt = Int(startTime)!
            
            // Current time
            let date = Date()
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HHmm"
            let currentime = dateFormatter1.string(from: date)
            let currentTimeInInt = Int(currentime)!

            // End Work hours
            let end = dataArray![3]
            let strEnd = String(end)
            let endtime = strEnd.replacingOccurrences(of: ":", with: "")
            let endTimeInInt = Int(endtime)!

            if currentTimeInInt > startTimeInInt && currentTimeInInt < endTimeInInt {
                displyAlert(strTitle: "", strMessage: Constants.WITHIN_WORK_HOURS)
            } else {
                displyAlert(strTitle: "", strMessage: Constants.OUTSIDE_WORK_HOURS)
            }
        }
    }

    func displyAlert(strTitle: String, strMessage: String)  {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petModel?.pets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PetNames) as! CustomTableViewCell
        
        // 1
        let data = petModel?.pets[indexPath.row]
        cell.titleLbl.text = data?.title
        
        // 2
        cell.imgIcon.loadFrom(URLAddress: data!.imageURL)
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.setUpShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.WebKit) as! WebKitViewController
        nextVC.strPetInfoURL = petModel?.pets[indexPath.row].contentURL ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

