//
//  MyRadioButtons.swift
//  radioButton
//
//  Created by Omar AlQasmi on 24/08/2021.
//

import UIKit
/**
     Use it to add radio buttons or check boxes
          
     * USAGE:
 
         1. Assign This class to a UITableView in your story board
         2. Connect an outlet to your controler class ex. @IBOutlet weak var tbl: MyRadioButtons!
         3. call the following function in your controler class
             tbl.prepareRadioButtonsTable(selectionStyle: .checkbox_optional_selection)
             tbl.setTableValues(dataArray: arr, preselected: [9])

         4. to get the selected button call this function
             tbl.getSelectedRadioButton()

       
     * EXAMPLES:
       
         A full example connecting a UITable assigned to a class MyRadioButtons and connecting a button action to get the selection:
         ````
         import UIKit

         class ViewController: UIViewController {

             @IBOutlet weak var tbl: MyRadioButtons!
             var arr = ["one","two","three","four","five","six","3","4","5","4","34","666"]
             
             override func viewDidLoad() {
                 super.viewDidLoad()
                 tbl.prepareRadioButtonsTable(selectionStyle: .checkbox_optional_selection)
                 tbl.setTableValues(dataArray: arr, preselected: [9])
                 
                 
             }
             @IBAction func btnGetSelection(_ sender: Any) {
                 let s = tbl.getSelectedRadioButton()
                 print(s)
             }
             

         }
         ````

     - Parameters:
         - selectionStyle: choose a style from enum, radio button/ check box (optional: default to .radio_manditory_selection)
         - dataArray: An array of strings having all  the buttons choices
         - preselected: an array of indexes of the pre selected choices (optional: default to nil)
     - Important:
          - to support iOS versions lower than iOS 13 please add image assets to your project and name them. (Check line: 160 & line: 167)

     - Author:
         Omar Al Qasmi
     - Version:
         1.0
*/

class MyRadioButtons: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    enum MyRadioSelectionStyle {
        case radio_manditory_selection
        case radio_optional_selection
        case checkbox_manditory_no_deselection
        case checkbox_manditory_atleast_one_selection
        case checkbox_optional_selection
    }
    class MyRadioButtonCell: UITableViewCell {
        var isMySelected = false
        var strText = ""
        var imgIcon = UIImageView()
        
    }

    private var isRadioButtonsDeselectionAllowed : Bool = false
    private var isCheckbox_manditory_atleast_one_selection : Bool = false
    private var mySelectionStyle : MyRadioSelectionStyle = .radio_manditory_selection
    private var isRadio : Bool = false
    private var arrRadioButtonsData : [String] = []
    private var arrRadioButtonsCells : [MyRadioButtonCell] = []

    public func getSelectedRadioButton() -> [Int] {
        var a : [Int] = []
        if let paths = self.indexPathsForSelectedRows{
            for item in paths {
                a.append(item.row)
            }

        }
        return a
    }
    public func prepareRadioButtonsTable(selectionStyle: MyRadioSelectionStyle = .radio_manditory_selection){


        delegate = self
        dataSource = self
        
        allowsMultipleSelection = true
        mySelectionStyle = selectionStyle

        setStyle()

    }
    func setTableValues(dataArray : [String], preselected: [Int]? = nil){
        arrRadioButtonsData = dataArray
        for item in dataArray {
            let c = MyRadioButtonCell()
            c.isMySelected = false
            c.strText = item
            arrRadioButtonsCells.append(c)
        }
        if let pre = preselected{
            for item in pre {
                self.selectRow(at: [0,item], animated: true, scrollPosition: .bottom)
            }
        }
    }
    private func setStyle(){
        switch mySelectionStyle {
        case .radio_manditory_selection:
            print("radio_manditory_selection")
            isRadio = true
            
        case .radio_optional_selection:
            print("radio_optional_selection")
            isRadioButtonsDeselectionAllowed = true
            isRadio = true

        case .checkbox_manditory_no_deselection:
            print("checkbox_manditory_no_deselection")

        case .checkbox_manditory_atleast_one_selection:
            print("checkbox_manditory_atleast_one_selection")
            isCheckbox_manditory_atleast_one_selection = true
            isRadioButtonsDeselectionAllowed = true

        case .checkbox_optional_selection:
            print("checkbox_optional_selection")
            isRadioButtonsDeselectionAllowed = true

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRadioButtonsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = arrRadioButtonsCells[indexPath.row]


        if #available(iOS 13.0, *) {
            cell.accessoryView = cell.imgIcon
            if cell.isSelected {
                cell.isHighlighted = true
                cell.imgIcon.isHighlighted = true
            }else{
                cell.isHighlighted = false
                cell.imgIcon.isHighlighted = false

            }

            if isRadio {
                cell.imgIcon = UIImageView.init(image: UIImage.init(systemName: "circle"), highlightedImage: UIImage.init(systemName: "largecircle.fill.circle"))
            }else{
                cell.imgIcon = UIImageView.init(image: UIImage.init(systemName: "circle"), highlightedImage: UIImage.init(systemName: "checkmark.circle.fill"))
            }
        } else {
            // Fallback on earlier versions
            if cell.isSelected {
                cell.isHighlighted = true
                cell.imgIcon.isHighlighted = true
            }else{
                cell.isHighlighted = false
                cell.imgIcon.isHighlighted = false

            }

            if isRadio {
                cell.imgIcon = UIImageView.init(image: UIImage.imageCompat(systemName: .circle), highlightedImage: UIImage.imageCompat(systemName: .circle_inset_filled))
            }else{
                cell.imgIcon = UIImageView.init(image: UIImage.imageCompat(systemName: .circle), highlightedImage: UIImage.imageCompat(systemName: .checkmark_circle_fill))
            }
            cell.accessoryView = cell.imgIcon

        }
        

        cell.accessoryView?.frame.size.width = 28
        cell.accessoryView?.frame.size.height = 28
        cell.textLabel?.text = cell.strText
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRadio {
            for i in tableView.indexPathsForSelectedRows! {
                tableView.deselectRow(at: i, animated: true)
            }
        }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !isRadioButtonsDeselectionAllowed{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

        }
        if isCheckbox_manditory_atleast_one_selection {
            var f = false
            for item in arrRadioButtonsCells {
                if item.isSelected {
                    f = true
                }
            }
            if f == false {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            }
        }
    }
    

}
