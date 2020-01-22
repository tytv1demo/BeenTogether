//
//  LoverLocationViewer.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import RxSwift

class LoverLocationViewer: UIView {
    
    // MARK: - Properties
    
    var messageLabel: UILabel!
    var lastUpdateTimeLabel: UILabel!
    var collapseExpandButton: UIButton!
    var location: BehaviorSubject<CustomLocation?>!
    var disposeBag: DisposeBag!
    
    // MARK: Initial
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainViews()
        disposeBag = DisposeBag()
    }
    
    convenience init(location: BehaviorSubject<CustomLocation?>) {
        self.init(frame: .zero)
        self.location = location
        
        subcribe()
    }
    
    // MARK: - Functions
    
    func setupMainViews() {
        setupBackgroundView()
        setupLabels()
        setupButtons()
        makeConstraints()
    }
    
    func setupBackgroundView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 8)
        layer.shadowRadius = 5
        layer.shouldRasterize = true
    }
    
    func setupButtons() {
        collapseExpandButton = UIButton(type: .custom)
        collapseExpandButton.tintColor = Colors.kPink
        let collapseExpandButtonImage = UIImage.awesomeIcon(name: .expand, textColor: Colors.kPink)
        collapseExpandButton.setImage(collapseExpandButtonImage, for: [])
        
        addSubview(collapseExpandButton)
    }
    
    func setupLabels() {
        lastUpdateTimeLabel = UILabel()
        lastUpdateTimeLabel.textColor = .black
        lastUpdateTimeLabel.font = UIFont.systemFont(ofSize: 15)
        lastUpdateTimeLabel.showSkeleton()
        
        messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.showSkeleton()
        
        addSubview(lastUpdateTimeLabel)
        addSubview(messageLabel)
    }
    
    func makeConstraints() {
        collapseExpandButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collapseExpandButton).inset(35)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        lastUpdateTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collapseExpandButton).inset(35)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions
    
    func setupActions() {
        collapseExpandButton.addTarget(self, action: #selector(handleCollapseExpandButtonDidTap), for: [.touchUpInside])
    }
    
    @objc func handleCollapseExpandButtonDidTap() {
        // todo
    }
    
    func subcribe() {
        location.subscribe(onNext: { [unowned self] (data) in
            guard let location = data else { return }
            
            self.lastUpdateTimeLabel.hideSkeleton()
            self.lastUpdateTimeLabel.text = "Your lover's location is on the map. Last updated in \(location.lastUpdate.format("HH:mm yyyy-MMM-dd"))"
            
            
        }).disposed(by: disposeBag)
    }
}
