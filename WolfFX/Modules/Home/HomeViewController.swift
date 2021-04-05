//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit
import Charts


let valueViewHeight = CGFloat(30.00)
let valueViewWidth = CGFloat(70.00)
let defaultWindowHeight = CGFloat(100.00)

typealias DrawCurrentPrice = (() -> Void)
typealias UpdateMinMaxLabels = (() -> Void)

class HomeViewController: UIViewController, NavigationDesign, HomeViewProtocol, ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
   
    @IBOutlet weak var thirtysecView: UIView!
    
    @IBOutlet weak var currentTimeOnChartLabel: UILabel!
    @IBOutlet weak var chartConteinerView: UIView!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var leverageLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var investmentTextField: UITextField!
    @IBOutlet weak var leverageTextField: UITextField!
    @IBOutlet weak var changeAssetButton: SubmitButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView! // for assets
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

    var maskView = UIView()
    var shapshots = [Snapshot]()
    var defaultWindowWidth = CGFloat(50.0)
    
    var expireScaleRange = CGFloat(0.0) // to check where is the right part of snapshot/rectange is
    var isBlackAndWhite = false
    var infoViewHeight = defaultWindowHeight
    var drawCurrentPrice: DrawCurrentPrice?
    var updateMinMaxLabels: UpdateMinMaxLabels?
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]  (_) in
            self?.getTime()
        })
    }
    
    func getTime() {
        let expiryValue = defaultExpiryTime
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
        investmentTextField.inputView = investmentPicker
        leverageTextField.inputView = leveragePicker
        tableView.delegate = self
        tableView.allowsSelection = true
        localize()
        presenter?.homeViewIsReady()
    }
    
    func localize() {
        investmentLabel.text = R.string.localizable.investment().localized()
        leverageLabel.text = R.string.localizable.leverage().localized()
        assetLabel.text = R.string.localizable.asset().localized()
        playButton.setTitle(R.string.localizable.inTrade().uppercased().localized(), for: .normal)
        currentTimeOnChartLabel.text = R.string.localizable.seconds()
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
    }
    
    func showHowToTradeAlert() {
        showPopup(title: nil, message: "If you want to know how to play please go to Settings - How to Trade", time: 5)
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
        lineChartView.xAxis.setLabelCount(5, force: true)
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        lineChartView.legend.enabled = false
        lineChartView.data = lineChartViewData
        lineChartView.delegate = self
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.minOffset = 0.0
        setupChartMask()
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
            infoView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -10.00),
            infoView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor)
        ])
        infoLabel.text = presenter?.textForInfoLabel()
        valueView.backgroundColor = UIColor.white
        valueView.addSubview(valueLabel)
        chartConteinerView.addSubview(valueView)
        chartConteinerView.bringSubviewToFront(valueView)
        NSLayoutConstraint.activate([
              valueView.topAnchor.constraint(equalTo: valueLabel.topAnchor),
              valueView.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
              valueView.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
              valueView.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor)
          ])
        valueView.layer.cornerRadius = 15
        valueView.layer.masksToBounds = true
    }
        
    func updateViewWith(price: Double, time: Int64) {
        guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
        let newTime = Double(time / 1000)
        let chartEntry = ChartDataEntry(x: newTime, y: price)
        dataSet.addEntry(chartEntry)
        if dataSet.entryCount > 200 {
            dataSet.removeFirst()
        }
        
      
        self.lineChartView.data?.notifyDataChanged()
        scaling()
        DispatchQueue.main.async {
            self.lineChartView.notifyDataSetChanged()
        }
        drawCurrentPrice = {
            self.valueLabel.text = String(price.truncate(places: 4))
            let chartFrame = self.lineChartView.frame
            let transform = self.lineChartView.getTransformer(forAxis: dataSet.axisDependency)
            let firstEntry = dataSet.entryForIndex(0)
            let valuePt = transform.pixelForValues(x: firstEntry?.x ?? 0, y: price)
            let valueViewFrame = CGRect(x: valuePt.x,
                                      y: valuePt.y - valueViewHeight / 2,
                                  width: valueViewWidth,
                                 height: valueViewHeight)
            self.valueView.frame = valueViewFrame
            let start = CGPoint(x: valueViewFrame.maxX, y: valueViewFrame.midY)
            let end = CGPoint(x: chartFrame.maxX, y: valueViewFrame.midY)
            self.drawDottedLine(start: start, end: end, view: self.lineChartView)
            self.updateSnapshotsFrames()
        }
    }

    func updateViewWith(min: Double, max: Double, minString: String, maxString: String) {
        updateMinMaxLabels = {
            self.minValueLabel.text = minString
            self.maxValueLabel.text = maxString
        }
         DispatchQueue.main.async {
            self.makeShift(currentMin: min.rounded(), currentMax: max.rounded()) // rounding for better performance
        }
         
        if let drawCurrentPrice = self.drawCurrentPrice {
            DispatchQueue.main.async {
              drawCurrentPrice()
            }
        }
    }

    private func scaling() {
        guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
        var yArray = [Double]()
                for i in 0..<dataSet.entryCount - 1 {
                    if let value = dataSet.entryForIndex(i)?.y {
                        yArray.append(value)
                    }
                }
        guard let max = yArray.max() else { return }
        guard let min = yArray.min() else { return }
        let average = (max - min) / 2
        let maxDeviation = abs(max - average)
        let minDeviation = abs(min - average)
        let deviation = [maxDeviation, minDeviation].max()
        lineChartView.leftAxis.axisMaximum = max + deviation! / 2
        lineChartView.leftAxis.axisMinimum = min - deviation! / 2
        self.lineChartView.data?.notifyDataChanged()
       // don't call notifyDataSetChanged() because it will be extra redrwaw
    }
    
        private func makeShift(currentMin: Double, currentMax: Double) {
            let center = (currentMax + currentMin ) / 2
            let average = (lineChartView.leftAxis.axisMaximum + lineChartView.leftAxis.axisMinimum) / 2
            let difference = center - average
                if difference > 0 {
                    lineChartView.leftAxis.axisMaximum = lineChartView.leftAxis.axisMaximum + difference
                    lineChartView.leftAxis.axisMinimum = lineChartView.leftAxis.axisMinimum + difference
                } else if difference < 0 {
                    lineChartView.leftAxis.axisMaximum = lineChartView.leftAxis.axisMaximum - abs(difference)
                    lineChartView.leftAxis.axisMinimum = lineChartView.leftAxis.axisMinimum - abs(difference)
                }
            self.lineChartView.data?.notifyDataChanged()
            // don't call notifyDataSetChanged() because it will be extra redrwaw
            var alpha = CGFloat(0)
            if (currentMax - currentMin) != 0 {
                alpha = CGFloat(1)
                let desireDevision = Double(defaultWindowHeight) / (currentMax - currentMin)
                let newYdif = Double(maskView.frame.size.height) / desireDevision
                lineChartView.leftAxis.axisMaximum = lineChartView.leftAxis.axisMinimum + newYdif
            } else {
               alpha = CGFloat(0)
            }
            self.lineChartView.data?.notifyDataChanged()
            UIView.animate(withDuration: 1) {
                self.infoView.alpha = alpha
                self.infoLabel.alpha = alpha
            }
            self.lineChartView.notifyDataSetChanged()
            updateMinMaxLabels?()
        }
        
    func update(snapshots: [Snapshot]) {
        self.shapshots = snapshots
        self.shapshots.forEach{chartConteinerView.addSubview($0.view!)}
    }
    
    func updateSnapshots(with snapshot: Snapshot) {
        let idArray = shapshots.map{$0.orderId}
        if !idArray.contains(snapshot.orderId) {
            shapshots.append(snapshot)
            chartConteinerView.addSubview(snapshot.view!)
        }
    }
    
    private func updateSnapshotsFrames() {
        guard let dataSet = lineChartView.data?.getDataSetByIndex(0) else { return }
        let count = dataSet.entryCount
        guard let lastEntry = dataSet.entryForIndex( count - 1) else { return }
        let transform = lineChartView.getTransformer(forAxis: dataSet.axisDependency)
        for snapshot in shapshots {
            let top = transform.pixelForValues(x:0, y: snapshot.max) // x is 0 because we need only calculate distance between Ymax and Y min which is the height of the snapshot(rectange)
            let bottom = transform.pixelForValues(x: 0, y: snapshot.min)
            let height = top.distance(to: bottom)
            var width = CGFloat(0.0)
            let startPixel = transform.pixelForValues(x: snapshot.startTime, y: 0)// y is 0 because we need to know the width of chart part
            if snapshot.startTime + Double(snapshot.duration) <= lastEntry.x {
                let endPixel = transform.pixelForValues(x: snapshot.startTime + Double(snapshot.duration), y: 0)
                width = startPixel.distance(to: endPixel)
            } else {
                // snapshot.duration is always 30 at version 2, needs refactor
                let borderPixel = transform.pixelForValues(x: lastEntry.x, y: 0)
                let chartWidthPart = borderPixel.distance(to: startPixel)
                let chartTimeDifference = lastEntry.x - snapshot.startTime
                let expiryTimeDifference = Double(snapshot.duration) - chartTimeDifference
                let expiryPart = calculateExpiryPart(from: expiryTimeDifference)
                width = chartWidthPart + expiryPart
            }
            let snapPt = transform.pixelForValues(x: snapshot.startTime, y: snapshot.max)
            let snapFrame = CGRect(x: snapPt.x,
                                   y: snapPt.y,
                               width: width,
                              height: height)
            
            snapshot.view?.frame = snapFrame
            if snapshot.isSuccess {
                snapshot.view?.paintWinColor()
            } else {
                snapshot.view?.paintLooseColor()
            }
            compareWithMaskAndUpdateFrame(snapshot: snapshot)
        }
    }

    private func calculateExpiryPart(from timeDifference: TimeInterval) -> CGFloat {
        return (defaultWindowWidth / 30) * CGFloat(timeDifference)
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
    
    func updateAssetButton(with title: String) {
        DispatchQueue.main.async {
            self.changeAssetButton.setTitle(title, for: .normal)
        }
    }
    
   private func updateInfoViewFrame() {
        let frame = CGRect(x: maskView.frame.maxX,
                           y: maskView.frame.midY - defaultWindowHeight / 2,
                               width: defaultWindowWidth,
                               height: infoViewHeight)
        infoView.frame = frame
        infoLabel.text = presenter?.textForInfoLabel()
    }
    
    private func compareWithMaskAndUpdateFrame(snapshot: Snapshot) {
        guard let snapshotView = snapshot.view else {return}
        if snapshotView.frame.origin.x < maskView.frame.origin.x {
            let difference = maskView.frame.origin.x - snapshotView.frame.origin.x
            if difference > snapshot.width {
                snapshot.view?.removeFromSuperview()
                shapshots.removeFirst()
                return
            }
            snapshot.view?.frame = CGRect(x: maskView.frame.origin.x,
                                y: snapshotView.frame.origin.y,
                            width: snapshotView.frame.width - difference,
                           height: snapshotView.frame.height)
            
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
        NSLayoutConstraint.activate([
        thirtysecView.bottomAnchor.constraint(equalTo: maskView.bottomAnchor)])
        thirtysecView.frame.size.width = defaultWindowWidth
        maskView.backgroundColor = UIColor.clear
        updateInfoViewFrame()
    }
     
    private func setupTextFieldsDesign() {
        let textFields = [investmentTextField, leverageTextField]
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
        showAlertWith(title: nil, message: R.string.localizable.executingYourOrderPleaseBePatient(), buttonTitle: R.string.localizable.oK(), action: nil)
    }
    
    private func dirtyFixForTopOffset() {
        tabBarController?.selectedIndex = 1
        tabBarController?.selectedIndex = 0
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
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == investmentPicker {
            return presenter?.investmentDataSource[row].title
        } else if pickerView == leveragePicker {
            return presenter?.leverageDataSource[row].title
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
        tableView.isHidden = true
        let asset = presenter?.tableDataSource?.grouppedAssets[indexPath.section]?[indexPath.row]
        changeAssetButton.setTitle(asset?.name, for: .normal)
        presenter?.selectedAsset = asset
        shapshots.removeAll()
    }
}
