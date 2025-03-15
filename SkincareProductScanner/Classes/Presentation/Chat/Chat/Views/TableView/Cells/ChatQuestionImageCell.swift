//
//  ChatQuestionImageCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 29.10.2024.
//

import UIKit
import Kingfisher

final class ChatQuestionImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    
    private lazy var pictureHeightConstraint = NSLayoutConstraint()
    
    private var imageSize: CGSize?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
        
        imageSize = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if pictureHeightConstraint.constant == 0, imageSize != nil {
            updateLayout()
        }
    }
}

// MARK: Public
extension ChatQuestionImageCell {
    func setup(url: URL) {
        pictureView.kf.setImage(with: url) { [weak self] result in
            guard let self, case let .success(result) = result else { return }
            
            self.imageSize = result.image.size
            self.setNeedsLayout()
            
            updateLayout()
        }
    }
    
    func setup(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            pictureView.image = image
            
            imageSize = image.size
            setNeedsLayout()
        }
    }
}

// MARK: Private
private extension ChatQuestionImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func updateLayout() {
        guard let imageSize else { return }
        
        let aspectHeight = imageSize.height / imageSize.width * frame.width
        pictureHeightConstraint.constant = aspectHeight
        
        layoutIfNeeded()
    
        guard let tableView = superview as? UITableView else { return }
    
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

// MARK: Make constraits
private extension ChatQuestionImageCell {
    func makeConstraints() {
        pictureHeightConstraint = pictureView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pictureHeightConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension ChatQuestionImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 45.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
