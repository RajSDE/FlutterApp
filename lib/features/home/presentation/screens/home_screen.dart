import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/config/routes/app_router.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_app/features/auth/presentation/screens/verification_screen.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_radii.dart';
import 'package:flutter_app/shared/theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshProfile(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated && state.user.userProfileId.isNotEmpty) {
      context.read<AuthBloc>().add(
            RefreshUserProfileRequested(
              userProfileId: state.user.userProfileId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = _buildHomeFeed(context);
        break;
      case 1:
        body = _buildSearchView(context);
        break;
      case 2:
        body = _buildProfileView(context);
        break;
      default:
        body = _buildHomeFeed(context);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 2) {
            _refreshProfile(context);
          }
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // TAB 0: Home Feed
  Widget _buildHomeFeed(BuildContext context) {
    final l10n = context.l10n;
    final categories = _categories(context);
    final deals = _deals(context);
    final products = _products(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1; // Swap to search tab
                    });
                  },
                  child: AbsorbPointer(
                    child: _SearchBox(
                      hint: l10n.homeSearchHint,
                      controller: _searchController,
                      onChanged: (val) {},
                    ),
                  ),
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _DealTile(deal: deals[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
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
    );
  }

  // TAB 1: Search View
  Widget _buildSearchView(BuildContext context) {
    final l10n = context.l10n;
    final allProducts = _products(context);

    // Filter products dynamically
    final filteredProducts = allProducts.where((_Product prod) {
      final name = prod.name.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    final popularTags = <String>[
      'Banana',
      'Milk',
      'Bread',
      'Eggs',
      'Chips',
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Explore Essentials',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SearchBox(
            hint: l10n.homeSearchHint,
            controller: _searchController,
            onChanged: (String val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          // Horizontal tags
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularTags.length,
              itemBuilder: (context, index) {
                final tag = popularTags[index];
                final isSelected =
                    _searchQuery.toLowerCase() == tag.toLowerCase();

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _searchController.text = tag;
                          _searchQuery = tag;
                        } else {
                          _searchController.clear();
                          _searchQuery = '';
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search_off_outlined,
                          size: 64,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No matching items found',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.76,
                    ),
                    itemBuilder: (context, index) {
                      return _ProductTile(product: filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Profile View
  Widget _buildProfileView(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final name = user?.name ?? 'John Doe';
        final email = user?.email ?? 'john.doe@example.com';
        final mobileNumber = user?.mobileNumber ?? '9631341874';
        final isMobileVerified = user?.mobileNumberVerified == 'Y';
        final isEmailVerified = user?.emailVerified == 'Y';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: <Widget>[
              // User info Card with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 44,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Account Settings list
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.phone_iphone_outlined,
                          color: AppColors.primary),
                      title: const Text('Mobile Number'),
                      subtitle: Text(mobileNumber),
                      trailing: isMobileVerified
                          ? const Icon(Icons.verified, color: Colors.blue)
                          : TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRouter.verification,
                                  arguments: VerificationArgs(
                                    isEmail: false,
                                    currentValue: mobileNumber,
                                  ),
                                );
                              },
                              child: const Text('Edit'),
                            ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email_outlined,
                          color: AppColors.primary),
                      title: const Text('Email Address'),
                      subtitle: Text(email),
                      trailing: isEmailVerified
                          ? const Icon(Icons.verified, color: Colors.blue)
                          : TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRouter.verification,
                                  arguments: VerificationArgs(
                                    isEmail: true,
                                    currentValue: email,
                                  ),
                                );
                              },
                              child: const Text('Edit'),
                            ),
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.language, color: AppColors.primary),
                      title: const Text('Change Language'),
                      trailing: SizedBox(
                        width: 120,
                        child: const AuthLanguageSwitcher(),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        // Pop to login and clear stacks
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.login,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Data mocks
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
  const _SearchBox({
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : const Icon(Icons.mic_none),
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
