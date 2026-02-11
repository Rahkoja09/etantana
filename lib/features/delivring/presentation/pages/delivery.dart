import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/delivring/presentation/widgets/minimal_delivery_view.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/shared/widget/map/mapbox_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Delivery extends StatefulWidget {
  final List<MapEntity> deliveries;

  const Delivery({Key? key, required this.deliveries}) : super(key: key);

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  late GlobalKey<DeliveryMapWidgetState> _mapKey;

  TextEditingController searchDelivering = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapKey = GlobalKey<DeliveryMapWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildMap()),
          Expanded(flex: 6, child: _buildDeliveryList()),
        ],
      ),
    );
  }

  Widget _buildDeliveryList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: StylesConstants.spacerContent),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: FloatingSearchBar(
              controller: searchDelivering,
              onSortTap: () {},
            ),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: widget.deliveries.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final delivery = widget.deliveries[index];
                  return MinimalDeliverieView(
                    delivery: delivery,
                    onTap: () {
                      final mapState = _mapKey.currentState;
                      mapState?.navigateToDelivery(delivery);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return DeliveryMapWidget(
      key: _mapKey,
      config: DeliveryMapConfig(
        center: Position(47.5, -19.0),
        zoom: 13.0,
        styleUri: 'mapbox://styles/rahkoja/cmlhvlh1e002l01r88yao1l2s',
        deliveries: widget.deliveries,
        pitch: 50,
        perimeterRadius: 2000.0,
        onMapCreated: () {},
        onDeliveryTap: (delivery) {
          print('Livraison sélectionnée: ${delivery.location}');
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class DeliveryListFromSupabase extends StatefulWidget {
  const DeliveryListFromSupabase({Key? key}) : super(key: key);

  @override
  State<DeliveryListFromSupabase> createState() =>
      _DeliveryListFromSupabaseState();
}

class _DeliveryListFromSupabaseState extends State<DeliveryListFromSupabase> {
  List<MapEntity> deliveries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeliveries();
  }

  Future<void> _fetchDeliveries() async {
    try {
      //  Exemple: avec Supabase
      // final response = await Supabase.instance.client
      //     .from('delivering')
      //     .select()
      //     .eq('date_of_delivering', DateTime.now().toString().split(' ')[0])
      //     .order('date_of_delivering', ascending: true);

      //  Transforme les données Supabase en DeliveryMarker
      // final List<dynamic> data = response;
      // setState(() {
      //   deliveries = data.map((item) {
      //     final userDetails = item['user_details'] as Map?;
      //     final location = userDetails?['address'] ?? 'Adresse inconnue';

      //     return DeliveryMarker(
      //       id: item['id'],
      //       location: location, // Ex: "antananarivo - andraisoro"
      //       latitude: userDetails?['latitude'],
      //       longitude: userDetails?['longitude'],
      //       status: item['status'] ?? 'pending',
      //       date: DateTime.parse(item['date_of_delivering']),
      //       price: (item['delivering_price'] ?? 0).toDouble(),
      //     );
      //   }).toList();
      //   isLoading = false;
      // });
    } catch (e) {
      print(' Erreur fetch: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Delivery(deliveries: deliveries);
  }
}
