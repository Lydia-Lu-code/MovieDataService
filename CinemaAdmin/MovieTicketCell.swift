//
//  MovieTicketCell.swift
//  CinemaAdmin
//
//  Created by Lydia Lu on 2024/12/25.
//

import UIKit

class MovieTicketCell: UITableViewCell {
    private let movieNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [movieNameLabel, dateLabel, timeLabel, priceLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 配置標籤樣式
        movieNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .gray
        priceLabel.font = .systemFont(ofSize: 15, weight: .medium)
        priceLabel.textAlignment = .right  // 設置文字右對齊
        
        NSLayoutConstraint.activate([
            // 電影名稱 - 左上
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            movieNameLabel.rightAnchor.constraint(lessThanOrEqualTo: priceLabel.leftAnchor, constant: -8),
            
            // 日期 - 左下
            dateLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 4),
            dateLabel.leftAnchor.constraint(equalTo: movieNameLabel.leftAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // 時段 - 日期旁邊
            timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            timeLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 8),
            
            // 票價 - 靠右
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.widthAnchor.constraint(equalToConstant: 100)  // 固定寬度確保對齊
        ])
    }
    
    func configure(with ticket: MovieTicket) {
        movieNameLabel.text = ticket.movieName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLabel.text = dateFormatter.string(from: ticket.showDate)
        
        timeLabel.text = ticket.showTime
        priceLabel.text = String(format: "NT$ %d", Int(ticket.totalAmount))  // 格式化價格顯示
    }
}
