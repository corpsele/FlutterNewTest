import UIKit
import PassKit
import ApplePayStubs

// MARK: - 主视图控制器
class ApplePayVC: UIViewController {
    
    
    // 1. 苹果支付按钮 (必须使用系统提供的按钮样式，不能自定义)
    private lazy var applePayButton: PKPaymentButton = {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startApplePay), for: .touchUpInside)
        return button
    }()
    
    // 2. 支付授权控制器
    private var paymentController: PKPaymentAuthorizationController?
    
    // 配置信息：请修改为你自己的配置
    private let merchantID = "merchant.com.eport.flutternewtest" // 必须与 Apple Developer 后台创建的一致
    private let countryCode = "CN" // 国家代码
    private let currencyCode = "CNY" // 货币代码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkApplePayAvailability()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Apple Pay 集成示例"
        
        view.addSubview(applePayButton)
        
        // 简单的布局约束
        NSLayoutConstraint.activate([
            applePayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applePayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            applePayButton.widthAnchor.constraint(equalToConstant: 200),
            applePayButton.heightAnchor.constraint(equalToConstant:44)
        ])
    }
    
    // 检查设备是否支持 Apple Pay
    private func checkApplePayAvailability() {
        // 检查硬件支持和是否有卡
        if PKPaymentAuthorizationController.canMakePayments() {
            print("设备支持 Apple Pay")
        } else {
            print("设备不支持 Apple Pay")
            applePayButton.isHidden = true
        }
        
        // 更精细的检查：检查是否支持特定的卡组织 (例如银联、Visa)
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: [.chinaUnionPay, .visa]) {
            print("设备已绑定支持的银行卡")
        } else {
            print("设备未绑定支持的银行卡，但可以添加")
        }
    }
    
    // MARK: - 触发支付流程
    @objc private func startApplePay() {
        // 1. 创建支付请求
        let request = PKPaymentRequest()
        
        // 2. 配置基础信息
        request.merchantIdentifier = merchantID
        request.countryCode = countryCode
        request.currencyCode = currencyCode
        
        // 3. 配置支持的银行卡网络
        request.supportedNetworks = [.chinaUnionPay, .visa, .masterCard, .amex]
        
        // 4. 配置商户能力 (3DS 必须要)
        request.merchantCapabilities = .capability3DS
        
        // 5. 配置订单金额明细
        // 数组最后一个是总金额，前面的为明细
        let amount = NSDecimalNumber(value: 100.00)
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "高级会员订阅", amount: amount),
            PKPaymentSummaryItem(label: "总计", amount: amount)
        ]
        
        // 6. (可选) 配置需要的配送/账单字段
        request.requiredBillingContactFields = [.postalAddress, .name]
        request.requiredShippingContactFields = [.name, .phoneNumber, .emailAddress]
        
        // 7. (可选) 配置配送方式
        let shippingMethod = PKShippingMethod(label: "标准快递", amount: NSDecimalNumber(value: 0.00))
        shippingMethod.identifier = "standard_shipping"
        shippingMethod.detail = "3-5 天送达"
        request.shippingMethods = [shippingMethod]
        
        // 8. 初始化控制器并设置代理
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = self
        
        // 9. 展示 Apple Pay 界面
        paymentController?.present(completion: nil)
        
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate (核心逻辑)
extension ApplePayVC: PKPaymentAuthorizationControllerDelegate {
    
    /// 用户授权支付结果（最重要的回调）
    /// - Parameters:
    ///   - controller: 控制器
    ///   - payment: 支付对象，里面包含加密的 Token
    ///   - completion: 完成回调，必须调用 .success, .failure 或 .pending
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                       didAuthorizePayment payment: PKPayment,
                                       handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        print("用户授权了支付，正在处理 Token...")
        
        // 1. 获取加密的支付 Token (PKPaymentToken)
        // 这里的 payment.token.paymentData 是发给后端扣款的核心数据
        guard let token = payment.token.paymentData as? Data else {
//            completion(PKPaymentAuthorizationResult(status: .failure, paymentMethods: nil))
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        // 2. (模拟) 发送 Token 到你的后端服务器
        // 在真实项目中，你需要使用 URLSession 将 tokenData (或转 Base64) 发送给你的服务器
        // 你的服务器需要拿到这些数据，再对接银行或 Apple Pay 支付网关完成真正的扣款
        
        sendTokenToBackend(tokenData: token, payment: payment) { [weak self] success in
            if success {
                // 后端告诉前端扣款成功
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                self?.showAlert(message: "支付成功！")
            } else {
                // 后端告诉前端扣款失败
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                self?.showAlert(message: "支付失败，请重试。")
            }
        }
    }
    
    /// 支付界面消失时的回调
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        // 无论成功、失败还是用户取消，最终都会走到这里
        controller.dismiss {
            print("Apple Pay 界面已关闭")
        }
    }
    
    /// (可选) 用户选择配送方式时的回调
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                       didSelectShippingMethod shippingMethod: PKShippingMethod,
                                       handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
        // 这里可以根据快递方式动态调整价格
        
//        let status: PKPaymentRequestStatus = .success
        let newTotal = NSDecimalNumber(value: 100.00) // 假设运费变了，重新计算总价
        let newItems = [
            PKPaymentSummaryItem(label: "商品", amount: NSDecimalNumber(value: 90.00)),
            PKPaymentSummaryItem(label: shippingMethod.label, amount: shippingMethod.amount),
            PKPaymentSummaryItem(label: "总计", amount: newTotal)
        ]
        
        let update = PKPaymentRequestShippingMethodUpdate(paymentSummaryItems: newItems)
        completion(update)
    }
    
    // MARK: - 模拟网络请求
    private func sendTokenToBackend(tokenData: Data, payment: PKPayment, completion: @escaping (Bool) -> Void) {
        
        // --- 真实环境代码示例 (仅供参考) ---
        /*
        let url = URL(string: "https://api.your-server.com/v1/pay/applepay")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 通常是将 Data 转 Base64 字符串发送
        let base64Token = tokenData.base64EncodedString(options: [])
        
        let payload: [String: Any] = [
            "token": base64Token,
            "transactionIdentifier": payment.token.transactionIdentifier,
            "amount": 100.00
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // ... 处理后端返回 ...
            completion(true) // 或 false
        }.resume()
        */
        
        // --- 模拟代码演示 (延迟 2 秒模拟网络请求) ---
        print("正在向后端发送 Token (Base64): \(tokenData.base64EncodedString())")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 假设后端返回成功
            completion(true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
