//
//  FloatRoundEntryView.swift
//  FloatWindow
//
//  Created by janlionly<jan_ron@qq.com> on 2019/11/15.
//  Copyright © 2018年 janlionly<jan_ron@qq.com>. All rights reserved.
//

import UIKit

open class FloatRoundEntryView: UIView {
    var clickedCallback: (()->())?

    deinit {
        clickedCallback = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        self.addGestureRecognizer(tap)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTap(gesture: UITapGestureRecognizer) {
        clickedCallback?()
    }


}
