import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout

final class HistoryViewController: UIViewController {
    //MARK: Constants
    private let viewModel: HistoryScreenViewModel
    private let mainTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Recent Creations"
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 32)
        return lb
    }()
    
    //MARK: Variables
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        return cv
    }()
    
    //MARK: Lifecycle
    init(viewModel: HistoryScreenViewModel = HistoryScreenViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
  
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupUI()
        setupLayots()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleImage), name: .saveImage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCreations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Methods
    
    private func setCreations() {
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async  {
                self?.viewModel.fetchCreations()
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func handleImage() {
        self.viewModel.fetchCreations()
    }
}
//MARK: - Extensions
private extension HistoryViewController {
    func setupUI() {
        self.view.addSubview(collectionView)
        self.view.addSubview(mainTitle)
    }
    
    func setupLayots() {
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - CollectionView Extensions
extension HistoryViewController: UICollectionViewDelegate {
    
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.creationsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UICollectionViewCell()
        }
        
        if let imageEntity = self.viewModel.images[indexPath.item],
           let imageData = imageEntity.image {
            let creation = UIImage(data: imageData) ?? UIImage()
            cell.configure(with: creation)
        }
        return cell

    }

}

extension HistoryViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2)
        let cellHeight = CGFloat(viewModel.images[indexPath.item]!.height)/1.5
        
        return CGSize(width: width, height: cellHeight)
    }
}


