import 'package:ewords/ui/my_widgets/my_snackbar.dart';
import 'package:ewords/utils/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAd {
  late RewardedAd _rewardedAd;
  bool _isAdLoaded = false;

  final BuildContext context;
  final Function onRewardEarned;

  RewardAd({required this.context, required this.onRewardEarned});

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Use test ad unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          //
          // SnackBarHelper.show(
          //   context: context,
          //   widget: MySnackBar.create(
          //     content: 'You have a chance to get a reward',
          //     label: 'Claim',
          //     onPressed: () {
          //       showRewardedAd();
          //     },
          //   ),
          //);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd() {
    if (_isAdLoaded) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewardEarned();
        },
      );
      loadRewardedAd(); // Load another ad
    } else {
      SnackBarHelper.show(
        context: context,
        widget: MySnackBar.create(
          content: 'Ad is not loaded!',
        ),
      );
    }
  }
}
