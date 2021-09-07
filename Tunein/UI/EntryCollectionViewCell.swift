//
//  EntryCollectionViewCell.swift
//  Tunein
//
//  Created by Zeev Vax on 9/6/21.
//

import Foundation
import UIKit
import SDWebImage

class EntryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var iconUIImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!

  private var tuneEntry: TuneElement?
  func setUp(tuneEntry: TuneElement) {
    self.tuneEntry = tuneEntry
    if tuneEntry.type == .audio {
      if let url = tuneEntry.imageUrlString?.httpsURL() {
        iconUIImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultStationImage"))
      }
    }
    titleLabel.text = tuneEntry.text
    subtitleLabel.text = tuneEntry.details
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    tuneEntry = nil
    iconUIImageView.image = UIImage(named: "defaultStationImage")
    titleLabel.text = nil
    subtitleLabel.text = nil
  }
}
