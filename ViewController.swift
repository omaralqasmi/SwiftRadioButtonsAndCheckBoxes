//
//  ViewController.swift
//  radioButton
//
//  Created by Omar AlQasmi on 18/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tbl: MyRadioButtons!
    var arr = ["zero","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.prepareRadioButtonsTable(selectionStyle: .radio_manditory_selection)
        tbl.setTableValues(dataArray: arr, preselected: [1])
        
        
    }
    @IBAction func btnGetSelection(_ sender: Any) {
        let s = tbl.getSelectedRadioButton()
        print(s)
    }
    

}


