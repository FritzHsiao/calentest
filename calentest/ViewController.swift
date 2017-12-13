import UIKit
import FSCalendar

class ViewController: UIViewController ,FSCalendarDataSource ,FSCalendarDelegate ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var tableV: UITableView!
    
    let but = UIBarButtonItem()
    var dateEvent = [TodayResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        but.title = "Edit"
        but.action = #selector(clickR)
        but.target = self
        
        navigationItem.rightBarButtonItem = but

    }
    
    @objc func clickR(){
        if but.title == "Edit" {
            but.title = "Done"
        } else {
            but.title = "Edit"
        }
        let bo = tableV.isEditing
        tableV.setEditing(!bo, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableV.reloadData()
    }
    
    var selecteddate: Date?
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selecteddate = date
        TodayResult.selectedList.removeAll()
        for a in TodayResult.List {
            if datecompare(date, a.date) == true {
                print("\n\(a.date)\n\(a.result)\nyes")
                let event = TodayResult(date: a.date, result: a.result)
                TodayResult.selectedList.append(event)
            } else {
                print("\(a.date)\n\(a.result)\nno")
            }
        }
        tableV.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let selectA = selecteddate
            let newVC = segue.destination as? newVC
            newVC?.selectDate = selectA
        }
    }
    
    func datecompare(_ selecteddate: Date, _ Resultdate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selecteddateString = formatter.string(from: selecteddate)
        let ResultdateString = formatter.string(from: Resultdate)
        if selecteddateString == ResultdateString {
            return true
        } else {
            return false
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodayResult.selectedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid)!
        cell.textLabel?.text = TodayResult.selectedList[indexPath.row].result
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodayResult.selectedList.remove(at: indexPath.row)
            TodayResult.List.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let result = TodayResult.List[fromIndexPath.row]
        let result2 = TodayResult.selectedList[fromIndexPath.row]
        TodayResult.selectedList.remove(at: fromIndexPath.row)
        TodayResult.List.remove(at: fromIndexPath.row)
        TodayResult.selectedList.insert(result2, at: to.row)
        TodayResult.List.insert(result, at: to.row)
        

    }
    
    

}

