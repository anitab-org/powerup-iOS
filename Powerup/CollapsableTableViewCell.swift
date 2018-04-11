import UIKit

class CollapsableTableViewCell: UITableViewCell {

    let detailLabel = UILabel()

    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let marginGuide = contentView.layoutMarginsGuide

        // configure detailLabel
        contentView.addSubview(detailLabel)
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -10).isActive = true
        detailLabel.numberOfLines = 0
        detailLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.6, blue: 0.6941176471, alpha: 1)
        detailLabel.font = UIFont(name: "montserrat", size: 17)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
