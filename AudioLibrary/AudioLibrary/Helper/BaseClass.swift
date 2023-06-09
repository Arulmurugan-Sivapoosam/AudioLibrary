//
//  BaseClass.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import Foundation
import UIKit

class BaseController: UIViewController {
  
  var navigationTitle: String? { nil }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    layoutViews()
    updateData()
    setColors()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    prepareNavigation()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layoutViews() {}
  func updateData() {}
  func setColors() {}
  
  func prepareNavigation() {
    guard let navigationTitle else {return}
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.topItem?.title = navigationTitle
  }
}

class BaseTable: UITableView {
  init() {
    super.init(frame: .zero, style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class BaseTableCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareCell()
  }
  
  private func prepareCell() {
    layoutViews()
    setColors()
    addActions()
    updateAttributes()
    updateData()
  }
  
  func updateAttributes() {
    selectionStyle = .none
  }
  
  func layoutViews() {}
  func updateData() {}
  func setColors() {}
  func addActions() {}
}

final class BaseButton: UIButton {
  var didPerformTapAction: (() -> Void)?
  init() {
    super.init(frame: .zero)
    self.addTarget(self, action: #selector(didPerformTap), for: .touchUpInside)
  }
  
  @objc
  private func didPerformTap() {
    didPerformTapAction?()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
