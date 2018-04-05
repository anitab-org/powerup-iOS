import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsableTableViewHeader, section: Int)
}

class CollapsableTableViewHeader: UITableViewHeaderFooterView {
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0

    let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        // Content View
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)

        let marginGuide = contentView.layoutMarginsGuide



        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.6, blue: 0.6941176471, alpha: 1)
        titleLabel.font = UIFont(name: "montserrat", size: 19)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true

        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsableTableViewHeader.tapHeader(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsableTableViewHeader else {
            return
        }

        delegate?.toggleSection(self, section: cell.section)
    }

    func setCollapsed(_ collapsed: Bool) {
    }


}
