//
//  Extensions.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import Foundation
import UIKit

extension UIView {
  @discardableResult func align(_ type1: NSLayoutConstraint.Attribute,
                                with view: UIView? = nil, on type2: NSLayoutConstraint.Attribute? = nil,
                                offset constant: CGFloat = 0,
                                priority: Float? = nil) -> NSLayoutConstraint? {
    guard let view = view ?? superview else {
      return nil
    }
    
    translatesAutoresizingMaskIntoConstraints = false
    let type2 = type2 ?? type1
    let constraint = NSLayoutConstraint(item: self, attribute: type1,
                                        relatedBy: .equal,
                                        toItem: view, attribute: type2,
                                        multiplier: 1, constant: constant)
    if let priority = priority {
      constraint.priority = UILayoutPriority(priority)
    }
    
    constraint.isActive = true
    
    return constraint
  }
  
  func alignEdges(with view: UIView? = nil, offset constant: CGFloat = 0) {
    align(.top, with: view, offset: constant)
    align(.bottom, with: view, offset: -constant)
    align(.leading, with: view, offset: constant)
    align(.trailing, with: view, offset: -constant)
  }
  
  func fixSize(_ size: CGSize) {
    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
  }
  
  func centerVertically(with view: UIView? = nil, offset: CGFloat = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    guard let secondView = view ?? self.superview else {return}
    self.centerYAnchor.constraint(equalTo: secondView.centerYAnchor, constant: offset).isActive = true
  }
  
  func centerHorizontally(with view: UIView? = nil, offset: CGFloat = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    guard let secondView = view ?? superview else {return}
    self.centerXAnchor.constraint(equalTo: secondView.centerXAnchor, constant: offset).isActive = true
  }
}

extension UITableViewCell {
  public static var reuseIdentifier: String { return String(describing: self) }
  static func register(to tableView: UITableView) {
    tableView.register(Self.self, forCellReuseIdentifier: Self.reuseIdentifier)
  }
}

extension UITableView {
  /// generic method returns the inferred type of cell using identifier from Reusable protocol
  func dequeueReusableCell<T: BaseTableCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unable to Dequeue Reusable Table View Cell with identitfier \(T.reuseIdentifier)")
    }
    return cell
  }
}
