//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit
import Charts

let defaultWindowHeight = CGFloat(50.00)
let valueViewHeight = CGFloat(30.00)
let valueViewWidth = CGFloat(70.00)

class HomeViewController: UIViewController, NavigationDesign, HomeViewProtocol, ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var chartConteinerView: UIView!
    @IBOutlet weak var expireTimeView: UIView!
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
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    
    var presenter: HomeEvents?
    var infoView = UIView()
    var valueView = UIView()
    var timer: Timer?
    var lineChartEntries = [ChartDataEntry]()
    
    let investmentPicker = UIPickerView()
    let leveragePicker = UIPickerView()
    let expiryPicker = UIPickerView()
    
    var maskView = UIView()
    var shapshots = [Snapshot]()
    var currentWindowWidth = CGFloat(0.0)
    var oneDivision = CGFloat(0.0)
    var expireScaleRange = CGFloat(0.0) // to check where is the right part of snapshot/rectange is
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        label.textAlignment = .center
        return label
    }()
    private let valueLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 10)
           label.textColor = UIColor.black
           label.textAlignment = .center
           return label
       }()
    private let shapeLayer = CAShapeLayer()
    
    override func viewWillAppear(_ animated: Bool) {
         localize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]  (_) in
            self?.getTime()
        })
    }

    func getTime() {
        guard let expiryValue = presenter?.selectedExpiry?.value else {return}
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let startDate = Date()
        if let expiryDate = calendar.date(byAdding: .second, value: Int(expiryValue), to: startDate) {
            let startTimeString = formatter.string(from: startDate)
            let expiryTimeString = formatter.string(from: expiryDate)
            startDateLabel.text = startTimeString
            expireDateLabel.text = expiryTimeString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartDesign()
        setupProgressBar()
        setupWindowWidth()
        dirtyFixForTopOffset()
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
    
    func reloadInvestmentPicker() {
        DispatchQueue.main.async {
            self.investmentPicker.reloadAllComponents()
        }
    }
    
    func updatePickersTextFields() {
        investmentTextField.text = presenter?.selectedInvestment?.title
        leverageTextField.text = presenter?.selectedLeverage?.title
        expiryTimeTextField.text = presenter?.selectedExpiry?.title
    }
    
    func updateChart(with entries: [PriceEntry]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        let xValuesNumberFormatter = ChartXAxisFormatter(dateFormatter: formatter)
        var lineChartEntries = [ChartDataEntry]()
        for priceEntry in entries {
            let timeInterval = priceEntry.timesTemp
            let xValue = timeInterval 
            let yValue = priceEntry.value
            let entry = ChartDataEntry(x: xValue, y: yValue)
            lineChartEntries.append(entry)
        }
        let lineSet = LineChartDataSet(entries: lineChartEntries, label: nil)
        lineSet.colors = [UIColor.red]
        lineSet.drawCirclesEnabled = false
        let gradColors = [UIColor.black.cgColor, UIColor.red.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: gradColors as CFArray, locations: nil)!
        lineSet.fillAlpha = 0.7
        lineSet.fill = Fill(linearGradient: gradient, angle: 90)
        lineSet.drawFilledEnabled = true
        let lineChartViewData = LineChartData(dataSets: [lineSet])
        lineChartViewData.setDrawValues(false)
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.setLabelCount(4, force: true)
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        lineChartView.legend.enabled = false
        lineChartView.data = lineChartViewData
        lineChartView.delegate = self
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.minOffset = 0.0
        setupChartMask()
        if let last = lineSet.entryForIndex(lineSet.count - 1)?.y {
      //      makeShift(for: last)
        }
    }
    
    func setupPlayButtonDesign() {
        guard let userCanPlay = presenter?.userCanPlay else {return}
        if userCanPlay {
            playButton.backgroundColor = UIColor.red
        } else {
            playButton.backgroundColor = UIColor.gray
        }
    }
    
    private func setupChartDesign() {
        lineChartView.isUserInteractionEnabled = false
        infoView.backgroundColor = UIColor.clear
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.yellow.withAlphaComponent(0.8).cgColor
        chartConteinerView.addSubview(infoView)
        chartConteinerView.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: infoLabel.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            infoView.trailingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
        ])
        infoLabel.text = presenter?.textForInfoLabel()
        valueView.backgroundColor = UIColor.white
        chartConteinerView.addSubview(valueView)
        chartConteinerView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
              valueView.topAnchor.constraint(equalTo: valueLabel.topAnchor),
              valueView.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
              valueView.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
              valueView.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor)
          ])
        valueView.layer.cornerRadius = 15
        valueView.layer.masksToBounds = true
    }
        
    func updateChartWithNewValue(assetPrice: AssetPrice) {
        guard let price = assetPrice.price else { return }
        valueLabel.text = String(price.truncate(places: 2))
        guard let priceTime = assetPrice.priceTime else { return }
        guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
        let newTime = Double(priceTime / 1000)
        let chartEntry = ChartDataEntry(x: newTime, y: price)
        dataSet.addEntry(chartEntry)
        if dataSet.entryCount > 200 {
            dataSet.removeFirst()
        }
        makeShift(for: price)
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        let chartFrame = lineChartView.frame
        let transform = lineChartView.getTransformer(forAxis: dataSet.axisDependency)
        let firstEntry = dataSet.entryForIndex(0)
        let valuePt = transform.pixelForValues(x: firstEntry?.x ?? 0, y: price)
        let valueViewFrame = CGRect(x: valuePt.x,
                                  y: valuePt.y - valueViewHeight / 2,
                              width: valueViewWidth,
                             height: valueViewHeight)
        self.valueView.frame = valueViewFrame
        let start = CGPoint(x: valueViewFrame.maxX, y: valueViewFrame.midY)
        let end = CGPoint(x: chartFrame.maxX, y: valueViewFrame.midY)
        drawDottedLine(start: start, end: end, view: self.lineChartView)
        for snapshot in shapshots {
            snapshot.view.removeFromSuperview()
            let top = transform.pixelForValues(x:0, y: snapshot.max) // x is 0 because we need only calculate distance between Ymax and Y min which is the height of the snapshot(rectange)
            let bottom = transform.pixelForValues(x: 0, y: snapshot.min)
            let height = top.distance(to: bottom)
            var width = CGFloat(0.0)
            let startPixel = transform.pixelForValues(x: snapshot.entry.x, y: 0)// y is 0 because we need to know the width of chart part
            if snapshot.entry.x + Double(snapshot.duration) <= newTime {
                let endPixel = transform.pixelForValues(x: snapshot.entry.x + Double(snapshot.duration), y: 0)
                width = startPixel.distance(to: endPixel)
            } else {                
                let borderPixel = transform.pixelForValues(x: chartEntry.x, y: 0)
                let chartWidthPart = borderPixel.distance(to: startPixel)
                let chartTimeDifference = newTime - snapshot.entry.x
                let expiryTimeDifference = Double(snapshot.duration) - chartTimeDifference
                checkExpireScaleRange(from: expiryTimeDifference)
                let expiryPart = calculateExpiryPart(from: expiryTimeDifference)
                width = chartWidthPart + expiryPart
            }
            let snapPt = transform.pixelForValues(x: snapshot.entry.x, y: snapshot.entry.y)
            let snapFrame = CGRect(x: snapPt.x,
                                   y: snapPt.y - height / 2,
                               width: width,
                              height: height)
            snapshot.view.frame = snapFrame
            chartConteinerView.addSubview(snapshot.view)
            compareWithMaskAndUpdateFrame(snapshot: snapshot)
            if snapshot.max > price && price > snapshot.min  {
                snapshot.paintWinColor()
            } else {
                snapshot.paintLooseColor()
            }
        }
    }

    private func checkExpireScaleRange(from timeDifference: TimeInterval) {
        if timeDifference <= 30  {
            expireScaleRange = oneDivision
        } else if timeDifference > 30 && timeDifference <= 60 {
            expireScaleRange = oneDivision * 2
        } else if timeDifference > 60 && timeDifference <= 120 {
            expireScaleRange = oneDivision * 3
        } else if timeDifference > 120 && timeDifference <= 900 {
            expireScaleRange = oneDivision * 4
        } else if timeDifference > 120 && timeDifference <= 3600 {
            expireScaleRange = oneDivision * 5
        }
    }
    
    private func calculateExpiryPart(from timeDifference: TimeInterval) -> CGFloat {
        var remainder = 0.0
        if (expireScaleRange / oneDivision) == 1 { //  30s
            return (oneDivision / 30) * CGFloat(timeDifference)
        } else if (expireScaleRange / oneDivision).rounded(.down) == 1 || (expireScaleRange / oneDivision).rounded() == 2 { // between 1m and 30s
            remainder = timeDifference - 30
            return oneDivision + (oneDivision / 30) * CGFloat(remainder)
        } else if (expireScaleRange / oneDivision).rounded(.down) == 2 || (expireScaleRange / oneDivision).rounded() == 3 { // between 2m and 1m
            remainder = timeDifference - 60
            return oneDivision * 2 + (oneDivision / 60) * CGFloat(remainder)
        } else if (expireScaleRange / oneDivision).rounded(.down) == 3 || (expireScaleRange / oneDivision).rounded() == 4 { // between 15m and 2m
            remainder = timeDifference - 120
            return oneDivision * 3 + (oneDivision / (13 * 60)) * CGFloat(remainder)
        } else if (expireScaleRange / oneDivision).rounded(.down) == 5 || (expireScaleRange / oneDivision).rounded() == 5 { // between 1H and 15m
            remainder = timeDifference - 900
            return oneDivision * 4 + (oneDivision / (45 * 60)) * CGFloat(remainder)
        } else {
            return CGFloat(0.0)
        }
    }
    
    private func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        shapeLayer.removeFromSuperlayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2] // 2 is the length of dash, 2 is length of the gap.
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    private func makeShift(for price: Double) {
       guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
       var yArray = [Double]()
            for i in 0..<dataSet.entryCount - 1 {
                if let value = dataSet.entryForIndex(i)?.y {
                    yArray.append(value)
                }
            }
        
        let avg = yArray.reduce(0, +) / Double(yArray.count)
        let avrLimit = abs(avg * 0.2)
        let filtered = yArray.filter{($0 - avg) < avrLimit}
        let max = filtered.max()
        let min = filtered.min()
        let rangeRate = (max! - min!) * 1.5
        lineChartView.leftAxis.axisMaximum = max! + rangeRate
        lineChartView.leftAxis.axisMinimum = min! - rangeRate
        
        if let max = presenter?.maxForSnapshot(), let min = presenter?.minForSnapshot() {
            updateInfoViewFrame(from: max, min: min)
            let average = (lineChartView.leftAxis.axisMaximum + lineChartView.leftAxis.axisMinimum) / 2
            let centralvalue = (max + min) / 2
            let difference = centralvalue - average
            if difference > 0 {
                lineChartView.leftAxis.axisMaximum = lineChartView.leftAxis.axisMaximum + difference
                lineChartView.leftAxis.axisMinimum = lineChartView.leftAxis.axisMinimum + difference
            } else if difference < 0 {
                lineChartView.leftAxis.axisMaximum = lineChartView.leftAxis.axisMaximum - abs(difference)
                lineChartView.leftAxis.axisMinimum = lineChartView.leftAxis.axisMinimum - abs(difference)
            }
        }
    }
    
    func updateAssetButton(with title: String) {
        DispatchQueue.main.async {
            self.changeAssetButton.setTitle(title, for: .normal)
        }
    }
    
    func updateInfoViewFrame(from max: Double, min: Double ) {
        guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
        guard let lastEntry = dataSet.entryForIndex(dataSet.entryCount - 1) else { return }
        let transform = lineChartView.getTransformer(forAxis: dataSet.axisDependency)
        let maxPt = transform.pixelForValues(x: lastEntry.x, y: max)
        let minPt = transform.pixelForValues(x: lastEntry.x, y: min)
        let height = maxPt.distance(to: minPt)
        let frame = CGRect(x: maskView.frame.maxX,
                           y: maskView.frame.midY - height / 2,
                       width: currentWindowWidth,
                      height: height)
        infoView.frame = frame
        infoLabel.text = presenter?.textForInfoLabel()
    }
    
    func updateMinValue(with string: String) {
        minValueLabel.text = string
    }
    
    func updateMaxValue(with string: String) {
        maxValueLabel.text = string
    }
    
    private func compareWithMaskAndUpdateFrame(snapshot: Snapshot) {
        if snapshot.view.frame.origin.x < maskView.frame.origin.x {
            let difference = maskView.frame.origin.x - snapshot.view.frame.origin.x
            if difference > snapshot.width {
                snapshot.view.removeFromSuperview()
                shapshots.removeFirst()
                return
            }
            snapshot.view.frame = CGRect(x: maskView.frame.origin.x,
                                y: snapshot.view.frame.origin.y,
                            width: snapshot.view.frame.width - difference,
                           height: snapshot.view.frame.height)
            
        }
    }
     
    private func setupChartMask() {
        // we should detect the visible part of the chart because the snapshot can cross the Y axis
        guard let chartDataSet = lineChartView.data?.dataSets[0] else {return}
        let transform = lineChartView.getTransformer(forAxis: chartDataSet.axisDependency)
        let minX = lineChartView.xAxis.axisMinimum
        let minY = lineChartView.leftAxis.axisMinimum
        let maxY = lineChartView.leftAxis.axisMaximum
        
        let leftTopPixel = transform.pixelForValues(x: minX, y: maxY)
        let width = lineChartView.frame.size.width - leftTopPixel.x
        
        let leftBottomPixel = transform.pixelForValues(x: minX, y: minY)
        let maskFrame = CGRect(x: leftTopPixel.x, y: 0, width: width, height: leftBottomPixel.y)
        maskView.frame = maskFrame
        chartConteinerView.addSubview(maskView)
        maskView.backgroundColor = UIColor.clear
        fixProgressViewFrame()
    }
     
    private func fixProgressViewFrame() {
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: maskView.bottomAnchor)
        ])
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
    }

    private func showTradeInInfoView() {
       let alert = UIAlertController(title: title,
            message: "Executing your order, please be patient",
            preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            alert.dismiss(animated: true, completion: nil)
        })        
    }
    
    private func dirtyFixForTopOffset() {
        tabBarController?.selectedIndex = 1
        tabBarController?.selectedIndex = 0
    }
    
    private func setupProgressBar() {
        guard let max = presenter?.expiryDataSource.count else {return}
        let ratio = Float(1) / Float(max)
        progressView.setProgress(Float(ratio), animated: true)
    }
    
    private func setupWindowWidth() {
        guard let count = presenter?.expiryDataSource.count else {return}
        let width = expireTimeView.frame.size.width / CGFloat(count)
        currentWindowWidth = width
        oneDivision = width
        expireScaleRange = width
    }
    
    private func makeSnapshot() {
        guard let chartDataSet = lineChartView.data?.dataSets[0] else {return}
        let indexOfLast = chartDataSet.entryCount - 1
        guard let entry = chartDataSet.entryForIndex(indexOfLast) else {return}
        guard let max = presenter?.maxForSnapshot() else {return}
        guard let min = presenter?.minForSnapshot() else {return}
        guard let duration = presenter?.selectedExpiry?.value else {return}
        let snapshot = Snapshot( entry: entry, max: max, min: min, width: currentWindowWidth, duration: duration, orderStatus: .live)
        snapshot.paintWinColor()
        shapshots.append(snapshot)
    }
    
    func initialXvalue() -> Double? {
        guard let chartDataSet = lineChartView.data?.dataSets[0] else {return nil}
        guard let firstEntry = chartDataSet.entryForIndex(0) else {return nil}
        let time = firstEntry.x
        return time
    }
    
    @IBAction func changeAssetPressed(_ sender: Any) {
        tableView.isHidden = false
    }
    
    @IBAction func tradeAction(_ sender: Any) {
        guard let userCanPlay = presenter?.userCanPlay else { return }
        if userCanPlay {
            makeSnapshot()
            showTradeInInfoView()
        }
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
            guard let count = presenter?.expiryDataSource.count else {return}
            let ratio = Float(row + 1) / Float(count)
            progressView.setProgress(Float(ratio), animated: true)
            let width = expireTimeView.frame.size.width / CGFloat(count) * CGFloat(row + 1)
            currentWindowWidth = width
            expireScaleRange = width
            
            if let value = selectedExpiry?.value {
                let intvalue = Int(value)
                let outsideInfoLabelRange = 0...120
                let insideInfoLabelRange = 121...3600
                if outsideInfoLabelRange.contains(intvalue) {
                    NSLayoutConstraint.activate([
                        infoView.topAnchor.constraint(equalTo: infoLabel.topAnchor),
                        infoView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
                        infoView.trailingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
                    ])
                } else if insideInfoLabelRange.contains(intvalue) {
                    NSLayoutConstraint.activate([
                        infoView.topAnchor.constraint(equalTo: infoLabel.topAnchor),
                        infoView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
                        infoView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
                        infoView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor)
                    ])
                }
                self.view.layoutIfNeeded()
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lineChartView.clear()
        infoView.removeFromSuperview()
        infoLabel.removeFromSuperview()
        tableView.isHidden = true
        let asset = presenter?.tableDataSource?.grouppedAssets[indexPath.section]?[indexPath.row]
        changeAssetButton.setTitle(asset?.name, for: .normal)
        presenter?.selectedAsset = asset        
    }
}
