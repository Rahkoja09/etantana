import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/cart/presentation/controller/cart_controller.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Chargement initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartControllerProvider.notifier).searchCart(null);
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
      ref.read(cartControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: state.isLoading && (state.carts?.isEmpty ?? true)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: (state.carts?.length ?? 0) + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < (state.carts?.length ?? 0)) {
                  final item = state.carts![index];
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