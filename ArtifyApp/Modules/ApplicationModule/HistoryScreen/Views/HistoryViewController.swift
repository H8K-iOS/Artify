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
        lb.font = .systemFont(ofSize: 32, weight: .bold)
        return lb
    }()
    
    //MARK: Variables
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isHidden = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        return cv
    }()
    
    private let firstPromptView = FirstPromptView()
    private weak var mainTabBar: MainTabBarController?
    
    //MARK: Lifecycle
    init(viewModel: HistoryScreenViewModel = HistoryScreenViewModel(), mainTabBar: MainTabBarController) {
        self.viewModel = viewModel
        self.mainTabBar = mainTabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupObservers()
        setupViewModel()
        checkDataConsistency()
    }
    
    //MARK: Setup Methods
    private func setupView() {
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(mainTitle)
    }
    
    private func setupConstraints() {
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImage), name: .saveImage, object: nil)
    }
    
    private func setupViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.checkDataConsistency()
            }
        }
        viewModel.fetchCreations()
    }
    
    //MARK: Methods
    @objc private func handleImage() {
        viewModel.fetchCreations()
    }
    
    @objc private func createFirstPromptButtonTapped() {
        mainTabBar?.switchToFirstTab()
    }
    
    private func checkDataConsistency() {
        if viewModel.images.isEmpty {
            showFirstPromptView()
        } else {
            firstPromptView.isHidden = true
        }
    }
    
    private func showFirstPromptView() {
        view.addSubview(firstPromptView)
        firstPromptView.createFirstPromptButton.addTarget(self, action: #selector(createFirstPromptButtonTapped), for: .touchUpInside)
        firstPromptView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(16)
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.creationsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UICollectionViewCell()
        }
        
        if let imageEntity = viewModel.images[indexPath.item],
           let imageData = imageEntity.image,
           let creation = UIImage(data: imageData) {
            cell.configure(with: creation)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let current = viewModel.images[indexPath.item] else { return }
        let vm = HistoryDetailScreenViewModel(current)
        let vc = HistoryDetailViewController(viewModel: vm)
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        let cellHeight = CGFloat(viewModel.images[indexPath.item]?.height ?? 0) / 1.5
        return CGSize(width: width, height: cellHeight)
    }
}
