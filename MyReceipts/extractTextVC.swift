//
//  extractTextVC.swift
//  MyReceipts
//
//  Created by Saemi An on 11/13/22.
//

import Vision
import UIKit

class extractTextVC: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "receipt2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        
        recognizeText(image: imageView.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
        }
        
        // Process request
        do {
            try handler.perform([request])
        }
        catch {
            label.text = "\(error)"
        }
    }
    
}
