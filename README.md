# iOS: Clean Architecture với RxSwift và MVVM-C
## Giới thiệu
**Clean Architecture** là một business architecture, nó tách rời những xử lý nghiệp vụ khỏi **UI** và **framework**. Clean Architecture phân rõ vai trò và trách nhiệm của từng layer trong kiến trúc của mình.

## Ưu nhược điểm
Về mặt **ưu điểm**, Clean architecture đạt được:
-   Giúp logic nghiệp vụ trở nên rõ ràng.
-   Không phụ thuộc vào framework
-   Các thành phần UI hoàn toàn tách biệt và độc lập.
-   Không phụ thuộc vào nguồn cung cấp dữ liệu.
-   Dễ dàng unit test.

Về mặt **nhược điểm**:
-   Clean architecture do phân tách cấu trúc thành nhiều tầng nên dẫn đến việc số lượng code sinh ra là rất lớn.

## Các thành phần chính
![enter image description here](https://raw.githubusercontent.com/sergdort/CleanArchitectureRxSwift/master/Architecture/Modules.png)

Về mặt cấu trúc,  **Clean architecture**  gồm 3 thành phần chính:

-   **Domain**: Là tầng chứa các thành phần cơ bản của ứng dụng và những gì ứng dụng có thể làm như các Entity, UseCase,... Nó không phụ thuộc vào bất cứ thành phần nào của UI hay bất kỳ Framework nào và cũng không implement bất kỳ một thành phần nào của ứng dụng tại tầng này.
-   **Platform**: Là tầng triển khai các phần cụ thể (concrete implementation) của tầng `Domain`. Tầng `Platform` sẽ che giấu đi những chi tiết được triển khai thực hiện. Bất cứ các task nào liên quan đến `call api, local DB, backend...` sẽ thực hiện ở đây.
-   **Application (hoặc Presentation)**: Là tầng chịu trách nhiệm cung cấp thông tin từ ứng dụng cho user và tiếp nhận những input từ user cho ứng dụng. Nó có thể được triển khai với các mô hình như MVC, MVP, MVVM. Đây là nơi chứa các  `UIView` và các `UIViewController`. Như bạn sẽ thấy trong example project, các `ViewController` hoàn toàn độc lập với tầng `Platform`. Nhiệm vụ duy nhất của một view controller là "bind" `UI` đến `Domain` để ứng dụng hoạt động.

## Chi tiết
**Domain**
`Entities` là các model
```swift
class GithubRepo: Mappable {
    var id: Int?
    var name: String?
    var fullname: String?
}
```

`UseCase` là nơi xử lý các business logic: Nó có thể sử dụng đến `Repository (ở tầng Domain)` để triển khai các task liên quan đến `api, local DB, backend...` hoặc **không** nếu như các use cases là các task không liên quan đến api, db. Tại UseCase sẽ inject **Repository** của tầng `Platform` hoặc **không**. Như trong ví dụ này thì Repository đã được `inject` vào UseCase bằng lib `Factory`.

```swift
protocol GithubRepoUseCaseType {
    func searchRepo(query: String) -> Observable<[GithubRepo]>
}

struct GithubRepoUseCase: GithubRepoRepositoryType {
    
    @Injected(\.gitHubRepoRepository) private var repository
    
    func searchRepo(query: String) -> Observable<[GithubRepo]> {
        return repository.searchRepo(query: query)
    }

}
```
**Platform**
Tại `Platform` chúng ta sẽ tiến hành triển khai các task như `call api, backend, db` như đã nói ở trên, và tiếp nhận data thông qua một **Repository**. Repository chính là nơi triển khai chi tiết (concrete implementation) các phần cụ thể của những use cases.

```swift
protocol GithubRepoRepositoryType {
    func searchRepo(query: String) -> Observable<[GithubRepo]>
}

struct GithubRepoRepository: GithubRepoRepositoryType {
    func searchRepo(query: String) -> Observable<[GithubRepo]> {
        let param: [String: Any] = [
            "q": query,
            "per_page": 10,
            "page": 1
        ]
        
        return APIService
            .shared
            .request(nonBaseResponse: GithubRepoAPIRouter.searchRepos(param: param))
            .compactMap({ (response: GithubRepoModel) -> [GithubRepo] in
                return response.githubRepos ?? []
            })
            .asObservable()
            .catchAndReturnElement([])
            .share()
    }
}
```
**Application**
`Application` là tầng chúng ta sẽ triển khai design pattern `MVVM-C` cùng với `RxSwift`, khiến việc binding trở nên dễ dàng hơn. Chữ `C` trong cụm từ `MVVM-C` mình sẽ giải thích bên dưới. Tầng `Application` sẽ chỉ dùng đến `UseCase` của `Domain` mà không quan tâm đến những tầng khác.

![enter image description here](https://github.com/sergdort/CleanArchitectureRxSwift/blob/master/Architecture/MVVMPattern.png?raw=true)

`ViewModel`  sẽ đóng vai trò chuẩn bị và trung chuyển dữ liệu. Nó sẽ có ba thành phần chính gồm:

-   **Input**: tập các trigger đầu vào được tiếp nhận từ View.
-   **Output**: tập các giá trị đầu ra để thực hiện bind lên View.
-   **func transform(input: Input) -> Output**  thực hiện biến đổi tập giá trị đầu vào thành kết quả đầu ra.

Ngoài ra, ViewModel còn chứa 2 thành phần được injected là `UseCase` chịu trách nhiệm thực hiện các xử lý business logic và `Router` chịu trách nhiệm điều hướng ứng dụng (chuyển màn hình, show alert,...). Router trong ví dụ sử dụng lib `XCoordinator`.

```swift
protocol EducaViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
```

```swift
class GithubRepoViewModel: EducaViewModel {
    
    struct Input {
        let triggerSearch: Driver<String>
        let triggerSelectIndexPath: Driver<(GithubRepo, IndexPath)>
    }
    
    struct Output {
        let repos: Driver<[GithubRepo]>
        let select: Driver<Void>
    }
    
    @Injected(\.gitHubRepoUseCase) private var useCase
    @Injected(\.githubCoordinator) private var router
    
    func transform(input: Input) -> Output {
        
        let repos = input.triggerSearch
            .skip(1) //skip first time
            .distinctUntilChanged()
            .debounce(.milliseconds(700))
            .flatMap { query in
                return self.useCase
                    .searchRepo(query: query)
                    .asDriverOnErrorJustComplete()
            }
        
        let select = input.triggerSelectIndexPath
            .do(onNext: { repo, indexPath in
                self.router?.trigger(.test(repoName: repo.fullname ?? ""))
            })
            .mapToVoid()
        
        return Output(repos: repos, select: select)
    }
}
```
**Chữ C trong MVVM-C**

Là `Coordinator`, một design pattern khá phổ biển ở Swift. Coordinator chứa các `Router`, đóng vài trò điều hướng ứng dụng. 

```swift
enum GithubRepoRoute: Route {
    case main
    case test(repoName: String)
}

class GithubRepoCoordinator: NavigationCoordinator<GithubRepoRoute> {

    init() {
        super.init(initialRoute: .main)
    }

    override func prepareTransition(for route: GithubRepoRoute) -> NavigationTransition {
        switch route {
        case .main:
	        //Router sẽ được register và inject vào VM ở đây
            Container.shared.githubCoordinator.register {
                self.unownedRouter
            }
            let vc = GithubRepoViewController()
            let vm = GithubRepoViewModel()
            vc.bind(to: vm)
            return .push(vc)
        case .test(let repoName):
            let vc = PresentationTestViewController()
            let vm = PresentationTestViewModel()
            vm.repoName = repoName
            vc.bind(to: vm)
            return .push(vc)
        }
    }
}
```

Và cuối cùng: `ViewController`, nơi user thao tác, nhận đầu vào và hiển thị các đầu ra tương ứng.

`ViewController` sẽ được adopt một **protocol** đó là `BindableType`. Tất cả các **UIViewController** khi adopt protocol này sẽ phải định nghĩa một property là `viewModel` chịu trách nhiệm lưu giữ instance của `ViewModel` trong `ViewController` và `func bindViewModel()` để thực hiện **binding** dữ liệu.

```swift
public protocol BindableType: class {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

public extension BindableType where Self: UIViewController {
    public func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
```

```swift
class GithubRepoViewController: EducaViewController<GithubRepoViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.registerCell(type: GithubRepoTableViewCell.self)
    }
    
    override func bindViewModel() {
        let input = GithubRepoViewModel.Input(triggerSearch:
                                                searchController.searchBar.rx.text.orEmpty.asDriver(),
                                              triggerSelectIndexPath: tableView.rx.modelAndIndexSelected(GithubRepo.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.repos
            .drive(tableView.rx.items) { tableView, index, element in
                let cell = tableView.dequeueReusableCell(type: GithubRepoTableViewCell.self, forIndexPath: IndexPath(index: index))
                cell.textLabel?.text = element.fullname
                return cell
            }
            .disposed(by: bag)
        
        output.select
            .drive()
            .disposed(by: bag)
    }
}
```






## Biểu đồ luồng chạy của ứng dụng

Luồng chạy thông qua `Sequence Diagram`:
```mermaid
sequenceDiagram
GithubRepoViewController ->> GithubRepoViewModel: 1. Driver.just(())
GithubRepoViewModel ->> GithubRepoUseCase: 2. searchRepo(query:) (UseCase)
GithubRepoUseCase ->> GithubRepoRepository: 3. searchRepo(query:) (Repository)
GithubRepoRepository ->> API: 4. request()
API -->> GithubRepoRepository: 5. response()
GithubRepoRepository -->> GithubRepoUseCase: 6. Get data success -> parser model
GithubRepoUseCase -->> GithubRepoViewModel: 7. Data
GithubRepoViewModel -->> GithubRepoViewController: 8. Binding data
```