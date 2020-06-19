import UIKit

protocol CatalogCollectionViewCellDelegate: class {
  func didPressZoomButton(_ sender: UIButton)
}

class CatalogCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var dressImageView: UIImageView!
  @IBOutlet weak var dressLabel: UILabel!
  @IBOutlet weak var selectedFlag: UIImageView!
  weak var cellDelegate: CatalogCollectionViewCellDelegate?
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    cellDelegate?.didPressZoomButton(sender)
  }
  
  override var isSelected: Bool {
    didSet {
      self.selectedFlag.image = isSelected ? UIImage(named: "tick") : nil
      self.dressLabel.backgroundColor = isSelected ? UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
    }
  }
}