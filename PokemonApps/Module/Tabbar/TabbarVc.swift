//
//  TabbarVc.swift
//  PokemonApps
//
//  Created by Kings on 05/08/25.
//

import UIKit
import XLPagerTabStrip

class TabbarVc: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

import XLPagerTabStrip

class MyPagerTabStripViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize buttonBar settings here
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildOneViewController")
        let child2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildTwoViewController")
        return [child1, child2]
    }
}

extension ChildOneViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Tab One")
    }
}

