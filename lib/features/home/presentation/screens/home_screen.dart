import 'package:flutter/material.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_radii.dart';
import 'package:flutter_app/shared/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = _categories(context);
    final deals = _deals(context);
    final products = _products(context);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _TopBar(
                      locationTitle: l10n.homeLocationTitle,
                      locationValue: l10n.homeLocationValue,
                      deliveryTime: l10n.homeDeliveryTime,
                      cartLabel: l10n.homeCart,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SearchBox(hint: l10n.homeSearchHint),
                    const SizedBox(height: AppSpacing.xl),
                    _HeroDeal(
                      title: l10n.homeHeroTitle,
                      subtitle: l10n.homeHeroSubtitle,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: l10n.homeCategoriesTitle,
                actionLabel: l10n.homeSeeAll,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              sliver: SliverGrid.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  return _CategoryTile(category: categories[index]);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: _SectionHeader(
                  title: l10n.homeDealsTitle,
                  actionLabel: l10n.homeSeeAll,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 132,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _DealTile(deal: deals[index]);
                  },
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.md),
                  itemCount: deals.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: _SectionHeader(
                  title: l10n.homeEssentialsTitle,
                  actionLabel: l10n.homeSeeAll,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              sliver: SliverGrid.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.76,
                ),
                itemBuilder: (context, index) {
                  return _ProductTile(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_Category> _categories(BuildContext context) {
    final l10n = context.l10n;
    return <_Category>[
      _Category(l10n.categoryFruits, Icons.apple, const Color(0xFFE8F7E8)),
      _Category(l10n.categoryDairy, Icons.local_drink, const Color(0xFFEAF2FF)),
      _Category(l10n.categorySnacks, Icons.fastfood, const Color(0xFFFFF0D9)),
      _Category(
          l10n.categoryBakery, Icons.bakery_dining, const Color(0xFFF4E9FF)),
      _Category(l10n.categoryDrinks, Icons.local_cafe, const Color(0xFFE4F8F4)),
      _Category(l10n.categoryPersonalCare, Icons.spa, const Color(0xFFFFE8EF)),
    ];
  }

  List<_Deal> _deals(BuildContext context) {
    final l10n = context.l10n;
    return <_Deal>[
      _Deal(
        title: l10n.dealMorningSaver,
        subtitle: l10n.dealMorningSaverSubtitle,
        icon: Icons.wb_sunny_outlined,
        color: const Color(0xFFFFD36E),
      ),
      _Deal(
        title: l10n.dealSnackRush,
        subtitle: l10n.dealSnackRushSubtitle,
        icon: Icons.bolt,
        color: const Color(0xFF9CE1D4),
      ),
    ];
  }

  List<_Product> _products(BuildContext context) {
    final l10n = context.l10n;
    return <_Product>[
      _Product(
        name: l10n.productBanana,
        quantity: '6 pcs',
        price: '₹48',
        oldPrice: '₹60',
        addLabel: l10n.productAdd,
        icon: Icons.eco,
        color: const Color(0xFFFFF1B8),
      ),
      _Product(
        name: l10n.productMilk,
        quantity: '500 ml',
        price: '₹32',
        oldPrice: '₹38',
        addLabel: l10n.productAdd,
        icon: Icons.local_drink,
        color: const Color(0xFFEAF2FF),
      ),
      _Product(
        name: l10n.productBread,
        quantity: '400 g',
        price: '₹45',
        oldPrice: '₹55',
        addLabel: l10n.productAdd,
        icon: Icons.breakfast_dining,
        color: const Color(0xFFFFE6CD),
      ),
      _Product(
        name: l10n.productEggs,
        quantity: '6 pcs',
        price: '₹72',
        oldPrice: '₹84',
        addLabel: l10n.productAdd,
        icon: Icons.egg_alt,
        color: const Color(0xFFF5E9D7),
      ),
      _Product(
        name: l10n.productPotatoChips,
        quantity: '52 g',
        price: '₹20',
        oldPrice: '₹25',
        addLabel: l10n.productAdd,
        icon: Icons.cookie,
        color: const Color(0xFFECE5FF),
      ),
    ];
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.locationTitle,
    required this.locationValue,
    required this.deliveryTime,
    required this.cartLabel,
  });

  final String locationTitle;
  final String locationValue;
  final String deliveryTime;
  final String cartLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.buttonPrimary,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: const Icon(Icons.flash_on, color: AppColors.buttonOnPrimary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                deliveryTime,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '$locationTitle $locationValue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: cartLabel,
          child: IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.mic_none),
      ),
    );
  }
}

class _HeroDeal extends StatelessWidget {
  const _HeroDeal({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0xFF1E4238),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD36E),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: const Icon(Icons.shopping_basket, size: 38),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
  });

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Icon(category.icon, color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealTile extends StatelessWidget {
  const _DealTile({required this.deal});

  final _Deal deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: deal.color,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: <Widget>[
          Icon(deal.icon, size: 42, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  deal.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  deal.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: product.color,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Icon(product.icon, size: 42),
                ),
              ),
            ),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              product.quantity,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        product.price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        product.oldPrice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(product.addLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}

class _Deal {
  const _Deal({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _Product {
  const _Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.oldPrice,
    required this.addLabel,
    required this.icon,
    required this.color,
  });

  final String name;
  final String quantity;
  final String price;
  final String oldPrice;
  final String addLabel;
  final IconData icon;
  final Color color;
}
