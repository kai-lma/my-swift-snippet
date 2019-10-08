import UIKit

// ビーコン検知確認用のViewController
class BeaconTestViewController: UIViewController {
    private var tableView: UITableView!
    private var bm: BeaconManager!
    private var inBeacons = [Beacon]()
    private var newInBeacons = [Beacon]()
    private var newOutBeacons = [Beacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        bm = BeaconManager()
        bm.delegate = self
        bm.startMonitoring()
    }
}

extension BeaconTestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = [inBeacons.count, newInBeacons.count, newOutBeacons.count]
        return numberOfRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension BeaconTestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["ALL IN", "NEW IN", "NEW OUT"]
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.numberOfLines = 0
        let cellData = [inBeacons, newInBeacons, newOutBeacons]
        cell.textLabel!.text = "\(cellData[indexPath.section][indexPath.row])"
        return cell
    }
}

extension BeaconTestViewController: BeaconManagerDelegate {
    func beaconManager(manager: BeaconManager, didReceiveNewInBeacons newInBeacons: [Beacon], newOutBeacons: [Beacon]) {
        self.inBeacons = manager.inBeacons
        self.newInBeacons = newInBeacons
        self.newOutBeacons = newOutBeacons
        tableView.reloadData()
    }
    
    func beaconManager(manager: BeaconManager, didEncounterError error: BeaconError) {
        switch error {
        case .LocationPermissionDenied:
            IDTDebugLog.print("User did not allow to access loccation info")
            
        case .RangingBeaconsDidFailFor(let region, let error):
            IDTDebugLog.print("Ranging Fail \(region) \(error)")
            
        case .DidFailWithError(let error):
            IDTDebugLog.print("Manager Failed with error \(error)")
            
        case .MonitoringDidFailFor(_, let error):
            IDTDebugLog.print("Monitoring Failed with error \(error)")
            
        case .DidFinishDeferredUpdatesWithError(let error):
            IDTDebugLog.print("Deferred updates Failed with error \(String(describing: error))")
        }
    }
}
