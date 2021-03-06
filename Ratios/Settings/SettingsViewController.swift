//
//  SettingsViewController.swift
//  Ratios
//
//  Created by Edward Wellbrook on 03/09/2017.
//  Copyright © 2017 Brushed Type. All rights reserved.
//

import UIKit
import SafariServices

fileprivate struct Actions {
    private init() {}

    static let handleCloseButtonPress = #selector(SettingsViewController.handleCloseButtonPress(_:))
    static let handleGitHubButtonPress = #selector(SettingsViewController.handleGitHubButtonPress(_:))
    static let handleFontButtonPress = #selector(SettingsViewController.handleFontButtonPress(_:))
    static let handleFontAuthorButtonPress = #selector(SettingsViewController.handleFontAuthorButtonPress(_:))
}

class SettingsViewController: UIViewController {

    let scrollView = UIScrollView(frame: .zero)

    let titleLabel = UILabel(frame: .zero)

    let aboutTextView = UITextView(frame: .zero)
    let aboutButton = RoundedButton(title: "Contribute on GitHub")

    let fontTextView = UITextView(frame: .zero)
    let fontButton = RoundedButton(title: "About Tofino")
    let fontAuthorButton = RoundedButton(title: "About Alanna")

    let versionLabel = UILabel(frame: .zero)


    override func loadView() {
        self.view = self.scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About"
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: Actions.handleCloseButtonPress)

        self.view.backgroundColor = Theme.backgroundColor

        self.titleLabel.text = "Ratios"
        self.titleLabel.font = UIFont.applicationFont(ofSize: 48, weight: .thin)
        self.titleLabel.textColor = Theme.accentColor

        self.aboutTextView.text = """
        Ratios is free and open source. If there's a feature you think's missing, \
        or something doesn't work right, you can help improve the app on GitHub.
        """
        self.aboutTextView.font = UIFont.applicationFont(ofSize: 16, weight: .light)
        self.aboutTextView.textColor = Theme.accentColor
        self.aboutTextView.isScrollEnabled = false
        self.aboutTextView.isEditable = false
        self.aboutTextView.isSelectable = false
        self.aboutTextView.textAlignment = .center
        self.aboutTextView.backgroundColor = .clear

        self.aboutButton.addTarget(self, action: Actions.handleGitHubButtonPress, for: .touchUpInside)

        let aboutStackView = UIStackView(arrangedSubviews: [
            self.aboutTextView,
            self.aboutButton
        ])

        aboutStackView.axis = .vertical
        aboutStackView.alignment = .fill
        aboutStackView.distribution = .equalSpacing
        aboutStackView.spacing = 8

        self.fontTextView.text = """
        Ratios uses the wonderful Tofino typeface by Alanna Munro. \
        Support Alanna's work, and consider using Tofino in your own projects.
        """
        self.fontTextView.font = UIFont.applicationFont(ofSize: 16, weight: .light)
        self.fontTextView.textColor = Theme.accentColor
        self.fontTextView.isScrollEnabled = false
        self.fontTextView.isEditable = false
        self.fontTextView.isSelectable = false
        self.fontTextView.textAlignment = .center
        self.fontTextView.backgroundColor = .clear

        self.fontButton.addTarget(self, action: Actions.handleFontButtonPress, for: .touchUpInside)
        self.fontAuthorButton.addTarget(self, action: Actions.handleFontAuthorButtonPress, for: .touchUpInside)

        let fontButtonsStackView = UIStackView(arrangedSubviews: [
            self.fontButton,
            self.fontAuthorButton
        ])

        fontButtonsStackView.axis = .horizontal
        fontButtonsStackView.alignment = .top
        fontButtonsStackView.distribution = .fillEqually
        fontButtonsStackView.spacing = 8

        let fontStackView = UIStackView(arrangedSubviews: [
            self.fontTextView,
            fontButtonsStackView
        ])

        fontStackView.axis = .vertical
        fontStackView.alignment = .fill
        fontStackView.distribution = .equalSpacing
        fontStackView.spacing = 8

        self.versionLabel.text = "\(AppInfo.shared.name) v\(AppInfo.shared.version) (\(AppInfo.shared.build))"
        self.versionLabel.font = UIFont.monospacedApplicationFont(ofSize: 13, weight: .medium)
        self.versionLabel.textColor = Theme.subtleAccentColor
        self.versionLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            aboutStackView,
            fontStackView,
            self.versionLabel
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 32

        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        stackView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1, constant: -32).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualToConstant: 480).isActive = true
    }

    @objc func handleCloseButtonPress(_ sender: AnyObject?) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func handleReviewButtonPress(_ sender: AnyObject?) {
        let url = URL(string: "https://itunes.apple.com/us/app/ratios/id1286379929?ls=1&mt=8&action=write-review")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc func handleGitHubButtonPress(_ sender: AnyObject?) {
        let url = URL(string: "https://github.com/brushedtype/Ratios")!
        let safariViewController = SFSafariViewController(url: url)
        self.navigationController?.present(safariViewController, animated: true, completion: nil)
    }

    @objc func handleFontButtonPress(_ sender: AnyObject?) {
        let url = URL(string: "http://tofino.losttype.com")!
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }

    @objc func handleFontAuthorButtonPress(_ sender: AnyObject?) {
        let url = URL(string: "https://alannamunro.com")!
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }

}
