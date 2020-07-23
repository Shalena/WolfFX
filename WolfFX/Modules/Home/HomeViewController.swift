//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, NavigationDesign, HomeViewProtocol, ChartViewDelegate {
   
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var chartConteinerView: UIView!
    
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var leverageLabel: UILabel!
    @IBOutlet weak var expiryTimeLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
   
    @IBOutlet weak var investmentTextField: UITextField!
    @IBOutlet weak var leverageTextField: UITextField!
    @IBOutlet weak var expiryTimeTextField: UITextField!
    
    @IBOutlet weak var changeAssetButton: SubmitButton!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var legalInformationTitle: UILabel!
    
    var presenter: HomeEvents?
    var infoView = UIView()
    var timer: Timer?
    var lineChartEntries = [ChartDataEntry]()
    var currentIndex = 0.0
    
    let investmentPicker = UIPickerView()
    let leveragePicker = UIPickerView()
    let expiryPicker = UIPickerView()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = UIColor.red
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
         localize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupTextFieldsDesign()
        if let title = presenter?.selectedAsset?.name {
            updateAssetButton(with: title)
        }
        investmentPicker.delegate = self
        investmentPicker.dataSource = self
        leveragePicker.delegate = self
        leveragePicker.dataSource = self
        expiryPicker.delegate = self
        expiryPicker.dataSource = self
        
        investmentTextField.inputView = investmentPicker
        leverageTextField.inputView = leveragePicker
        expiryTimeTextField.inputView = expiryPicker
    
        tableView.delegate = self
        tableView.allowsSelection = true
        presenter?.homeViewIsReady()
        localize()
    }
    
    func localize() {
        investmentLabel.text = R.string.localizable.investment().localized()
        leverageLabel.text = R.string.localizable.leverage().localized()
        expiryTimeLabel.text = R.string.localizable.expiryTime().localized()
        assetLabel.text = R.string.localizable.asset().localized()
        playButton.setTitle(R.string.localizable.inTrade().uppercased().localized(), for: .normal)
    }
     
    func updateAssetsTable() {
        guard tableView != nil else {
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateChart(with entries: [PriceEntry]) {
           setupChartDesign()
           lineChartEntries = [ChartDataEntry]()
           let values = entries.map({$0.value})
           for i in 0..<values.count {
               let chartDataEntry = ChartDataEntry(x: Double(i), y: values[i])
               lineChartEntries.append(chartDataEntry)
           }
           let lineSet = LineChartDataSet(entries: lineChartEntries, label: nil)
           lineSet.colors = [UIColor.red]
           lineSet.drawCirclesEnabled = false
           let gradColors = [UIColor.red.cgColor, UIColor.clear.cgColor]
           let colorLocations:[CGFloat] = [0.0, 1.0]
           if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
               lineSet.fill = Fill(linearGradient: gradient, angle: 90.0)
               lineSet.drawFilledEnabled = true
           }
      
           let lineChartViewData = LineChartData(dataSets: [lineSet])
           lineChartViewData.setDrawValues(false)
           lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
           lineChartView.xAxis.valueFormatter = presenter?.axisValueFormatter
           lineChartView.xAxis.labelTextColor = UIColor.white
           lineChartView.leftAxis.labelTextColor = UIColor.white
           lineChartView.rightAxis.enabled = false
           lineChartView.xAxis.setLabelCount(3, force: true)
           lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 18)
           lineChartView.legend.enabled = false
           lineChartView.data = lineChartViewData
           lineChartView.delegate = self
           lineChartView.xAxis.avoidFirstLastClippingEnabled = true
       }
       
    private func setupChartDesign() {
        infoView.backgroundColor = UIColor.clear
        infoView.layer.borderWidth = 2.0
        infoView.layer.borderColor = UIColor.yellow.cgColor
        chartConteinerView.addSubview(infoView)
        
        chartConteinerView.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: infoLabel.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            infoView.trailingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
        ])
        infoLabel.text = presenter?.textForInfoLabel()
    }
        
    func updateChartWithNewValue(assetPrice: AssetPrice) {
        guard let newValue = assetPrice.price else { return }
        let currentSet = lineChartView.data?.getDataSetByIndex(0)
        currentIndex =  Double(currentSet?.entryCount ?? 0)
        let chartEntry = ChartDataEntry(x: currentIndex, y: newValue)
        currentSet?.addEntry(chartEntry)
        let xAxis = self.lineChartView.xAxis 
        xAxis.valueFormatter = presenter?.axisValueFormatter
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.setVisibleXRangeMaximum(20)
        lineChartView.moveViewToX(currentIndex)
 
        let highlight = Highlight(x: currentIndex, y: newValue, dataSetIndex: 0)
        lineChartView.highlightValue(highlight, callDelegate: true)
    }

    internal func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
           guard let chartDataSet = lineChartView.data?.dataSets[0] else {return} // get dataSet used by chart
           guard let chartView = chartView as? LineChartView else {return}
           let transform = chartView.getTransformer(forAxis: chartDataSet.axisDependency)
           let pt = transform.pixelForValues(x: highlight.x, y: highlight.y)
           print(pt)
           let frame = CGRect(x: pt.x, y: pt.y - 25, width: 50, height: 50)
           infoView.frame = frame
    }
    
    private func setupTextFieldsDesign() {
        let textFields = [investmentTextField, leverageTextField, expiryTimeTextField]
               for textField in textFields {
                   let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
                   let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                   imageView.image = R.image.arrowDown()
                   container.addSubview(imageView)
                   textField?.rightViewMode = .always
                   textField?.rightView = container
               }
        investmentTextField.text = presenter?.selectedInvestment?.title
        leverageTextField.text = presenter?.selectedLeverage?.title
        expiryTimeTextField.text = presenter?.selectedExpiry?.title
    }
    
    func updateAssetButton(with title: String) {
        DispatchQueue.main.async {
            self.changeAssetButton.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func changeAssetPressed(_ sender: Any) {
        tableView.isHidden = false
    }
    
    @IBAction func tradeAction(_ sender: Any) {
        presenter?.tradeAction()
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == investmentPicker {
            return presenter?.investmentDataSource.count ?? 0
        } else if pickerView == leveragePicker {
            return presenter?.leverageDataSource.count ?? 0
        } else if pickerView == expiryPicker {
            return presenter?.expiryDataSource.count ?? 0
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == investmentPicker {
            return presenter?.investmentDataSource[row].title
        } else if pickerView == leveragePicker {
            return presenter?.leverageDataSource[row].title
        } else if pickerView == expiryPicker {
            return presenter?.expiryDataSource[row].title
        } else {
           return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == investmentPicker {
            let selectedInvestment = presenter?.investmentDataSource[row]
            investmentTextField.text = selectedInvestment?.title
            presenter?.selectedInvestment = selectedInvestment
        } else if pickerView == leveragePicker {
            let selectedLeverage = presenter?.leverageDataSource[row]
            presenter?.selectedLeverage = selectedLeverage
            leverageTextField.text = selectedLeverage?.title
        } else if pickerView == expiryPicker {
            let selectedExpiry = presenter?.expiryDataSource[row]
            expiryTimeTextField.text = selectedExpiry?.title
            presenter?.selectedExpiry = selectedExpiry
        }
        infoLabel.text = presenter?.textForInfoLabel()
        self.view.endEditing(true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.tableDataSource?.grouppedAssets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.tableDataSource?.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tableDataSource?.grouppedAssets[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identidier = "AssetCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identidier, for: indexPath) as? AssetCell {
            let text = presenter?.tableDataSource?.grouppedAssets[indexPath.section]?[indexPath.row].name ?? ""
            presenter?.update(cell: cell, with: text)
        return cell
        } else {
            return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.isHidden = true
        let asset = presenter?.tableDataSource?.grouppedAssets[indexPath.section]?[indexPath.row]
        changeAssetButton.setTitle(asset?.name, for: .normal)
        presenter?.selectedAsset = asset        
    }
}
