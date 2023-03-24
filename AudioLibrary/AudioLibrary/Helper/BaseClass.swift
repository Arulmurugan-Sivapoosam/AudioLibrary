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
