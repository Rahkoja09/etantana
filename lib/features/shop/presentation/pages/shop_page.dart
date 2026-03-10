import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Chargement initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopControllerProvider.notifier).searchShop(null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(shopControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: state.isLoading && (state.shops?.isEmpty ?? true)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: (state.shops?.length ?? 0) + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < (state.shops?.length ?? 0)) {
                  final item = state.shops![index];
                  return ListTile(
                    title: Text(item.id ?? "No ID"),
                    subtitle: Text(item.createdAt?.toString() ?? ""),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
    );
  }
}