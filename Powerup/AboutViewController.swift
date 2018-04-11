import UIKit

class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sections = sectionsData
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundView = nil
    }

    // MARK: Action

    @IBAction func homeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
//
// MARK: - View Controller DataSource and Delegate
//
extension AboutViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : 1
    }

    // Cell

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsableTableViewCell ??
        CollapsableTableViewCell(style: .default, reuseIdentifier: "cell")
        let powerupDetail: PoweupInfo = sections[indexPath.section].powerupDetail
        cell.detailLabel.text = powerupDetail.detail
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsableTableViewHeader ?? CollapsableTableViewHeader(reuseIdentifier: "header")
        header.contentView.backgroundColor = UIColor.clear
        header.backgroundView = UIView()
        header.titleLabel.text = sections[section].powerupQues
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}

//
// MARK: - Section Header Delegate
//
extension AboutViewController: CollapsibleTableViewHeaderDelegate {

    func toggleSection(_ header: CollapsableTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)

        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }

}
