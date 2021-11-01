//
//  HelperClasses.swift
//  MCounter
//
//  Created by apple on 10/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldPadding : UITextField {

  let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}



class UITextViewPadding : UITextView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
}
