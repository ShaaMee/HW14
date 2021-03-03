//
//  WeatherTableViewCell.swift
//  Homework_11
//
//  Created by user on 19.01.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var minTempLabel: UILabel!
  @IBOutlet weak var maxTempLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
