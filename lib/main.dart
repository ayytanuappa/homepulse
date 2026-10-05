import 'package:flutter/material.dart';

void main() {
  runApp(const HomePulseApp());
}

class HomePulseApp extends StatelessWidget {
  const HomePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomePulse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePulseHome(),
    );
  }
}

class HomePulseHome extends StatefulWidget {
  const HomePulseHome({super.key});

  @override
  State<HomePulseHome> createState() => _HomePulseHomeState();
}

class _HomePulseHomeState extends State<HomePulseHome>
    with SingleTickerProviderStateMixin {
  int page = 0;
  bool ecoMode = true;
  bool notifications = true;
  int notificationCount = 3;
  bool autoPower = false;
  bool selectedAC = false;
  bool selectedFan = false;
  bool selectedLight = false;
  double targetUsage = 60;
  String room = 'Living Room';
  String priority = 'Energy Saving';

  late TabController tabController;

  final appliances = [
    ['Air Conditioner', Icons.ac_unit, '1.8 kWh'],
    ['Ceiling Fan', Icons.toys, '0.4 kWh'],
    ['Smart Lights', Icons.lightbulb, '0.2 kWh'],
    ['Refrigerator', Icons.kitchen, '1.1 kWh'],
    ['Television', Icons.tv, '0.6 kWh'],
    ['Washing Machine', Icons.local_laundry_service, '0.8 kWh'],
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HomePulse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: Badge(
              label: Text('$notificationCount'),
              isLabelVisible: notifications && notificationCount > 0,
              backgroundColor: notifications ? Colors.teal : Colors.grey,
              child: Icon(
                notifications
                    ? Icons.notifications_outlined
                    : Icons.notifications_off_outlined,
              ),
            ),
            onPressed: notifications ? openNotificationsSheet : null,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  openProfileDialog();
                  break;
                case 'Settings':
                  setState(() => page = 2);
                  break;
                case 'Help':
                  openHelpDialog();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Profile', child: Text('Profile')),
              PopupMenuItem(value: 'Settings', child: Text('Settings')),
              PopupMenuItem(value: 'Help', child: Text('Help')),
            ],
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: IndexedStack(
        index: page,
        children: [
          dashboardPage(),
          appliancesPage(),
          settingsPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addApplianceDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Appliance'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (value) {
          setState(() {
            page = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_other_outlined),
            selectedIcon: Icon(Icons.devices_other),
            label: 'Appliances',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('HomePulse User'),
            accountEmail: const Text('Smart Home Monitor'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.home, size: 32),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blue],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              setState(() => page = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text('My Appliances'),
            onTap: () {
              setState(() => page = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.energy_savings_leaf),
            title: const Text('Energy Goals'),
            onTap: () {
              Navigator.pop(context);
              energyGoalDialog();
            },
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About HomePulse'),
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'HomePulse helps households monitor appliances, '
                  'energy consumption and saving goals.',
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Exit'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget dashboardPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Evening 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 5),
          const Text('Here is your home energy overview.'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: statCard(
                  'Today',
                  '7.8 kWh',
                  Icons.bolt,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: statCard(
                  'Savings',
                  '18%',
                  Icons.trending_down,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.energy_savings_leaf),
                      SizedBox(width: 8),
                      Text(
                        'Monthly Energy Goal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('68% used'),
                      Text('Target: 60 kWh'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Energy Insights',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.ac_unit),
                  ),
                  title: const Text('Air Conditioner'),
                  subtitle: const Text('Highest energy consumer'),
                  trailing: const Chip(
                    label: Text('1.8 kWh'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.lightbulb),
                  ),
                  title: const Text('Smart Lights'),
                  subtitle: const Text('Efficient usage detected'),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Eco Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CircularProgressIndicator(
                    value: 0.82,
                    strokeWidth: 10,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '82 / 100',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Excellent energy-saving performance'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.power_settings_new),
                label: const Text('Power Saving'),
                onPressed: () => showMessage('Power saving enabled'),
              ),
              FilterChip(
                selected: ecoMode,
                label: const Text('Eco Mode'),
                onSelected: (value) {
                  setState(() => ecoMode = value);
                },
              ),
              ChoiceChip(
                selected: priority == 'Energy Saving',
                label: const Text('Energy Saving'),
                onSelected: (_) {
                  setState(() => priority = 'Energy Saving');
                },
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget appliancesPage() {
    return Column(
      children: [
        Material(
          child: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Saving'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              applianceGrid(appliances),
              applianceGrid(appliances.take(3).toList()),
              applianceGrid(appliances.skip(2).toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget applianceGrid(List<List<dynamic>> data) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => applianceDetails(item),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(item[1], size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(item[2]),
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(value: 0.45),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => applianceDetails(item),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openNotificationsSheet() {
    final notificationList = [
      'Air conditioner schedule updated for 7:00 PM.',
      'Peak usage alert: 12% above your target this week.',
      'Smart lighting saved 1.4 kWh today.',
      'Water heater ready to power down automatically.',
    ];

    setState(() {
      notificationCount = 0;
    });

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...notificationList.map(
                  (message) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.teal),
                          const SizedBox(width: 10),
                          Expanded(child: Text(message)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showMessage('Notifications marked as read');
                      },
                      child: const Text('Mark all as read'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 36,
                  child: Icon(Icons.person, size: 36),
                ),
                const SizedBox(height: 12),
                const Text(
                  'HomePulse User',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text('smart.home@example.com'),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Household'),
                  subtitle: const Text('Sunset Villa'),
                ),
                ListTile(
                  leading: const Icon(Icons.energy_savings_leaf),
                  title: const Text('Energy Goal'),
                  subtitle: const Text('Reduce usage by 30%'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showMessage('Profile updated');
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. View live energy usage on the dashboard.'),
              SizedBox(height: 8),
              Text('2. Set appliance goals and eco mode from Settings.'),
              SizedBox(height: 8),
              Text('3. Use notification alerts to track unusual activity.'),
              SizedBox(height: 8),
              Text('4. Contact support at support@homepulse.app'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget settingsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Home Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Eco Mode'),
                subtitle: const Text('Automatically reduce energy usage'),
                value: ecoMode,
                onChanged: (value) {
                  setState(() => ecoMode = value);
                },
              ),
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Receive energy alerts'),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                    notificationCount = value ? 3 : 0;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Automatic Power Control'),
                subtitle: const Text('Turn appliances off automatically'),
                value: autoPower,
                onChanged: (value) {
                  setState(() => autoPower = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Usage Target',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: targetUsage,
                  min: 20,
                  max: 100,
                  divisions: 8,
                  label: '${targetUsage.round()} kWh',
                  onChanged: (value) {
                    setState(() => targetUsage = value);
                  },
                ),
                Text('${targetUsage.round()} kWh'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferred Room',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: room,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.room),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Living Room',
                      child: Text('Living Room'),
                    ),
                    DropdownMenuItem(
                      value: 'Bedroom',
                      child: Text('Bedroom'),
                    ),
                    DropdownMenuItem(
                      value: 'Kitchen',
                      child: Text('Kitchen'),
                    ),
                    DropdownMenuItem(
                      value: 'Study Room',
                      child: Text('Study Room'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => room = value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Card(
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('AC monitored'),
                value: selectedAC,
                onChanged: (value) {
                  setState(() => selectedAC = value ?? false);
                },
              ),
              CheckboxListTile(
                title: const Text('Fan monitored'),
                value: selectedFan,
                onChanged: (value) {
                  setState(() => selectedFan = value ?? false);
                },
              ),
              CheckboxListTile(
                title: const Text('Lights monitored'),
                value: selectedLight,
                onChanged: (value) {
                  setState(() => selectedLight = value ?? false);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Energy Priority',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RadioGroup<String>(
          groupValue: priority,
          onChanged: (value) {
            if (value != null) {
              setState(() => priority = value);
            }
          },
          child: const Column(
            children: [
              RadioListTile<String>(
                title: Text('Energy Saving'),
                value: 'Energy Saving',
              ),
              RadioListTile<String>(
                title: Text('Comfort'),
                value: 'Comfort',
              ),
              RadioListTile<String>(
                title: Text('Balanced'),
                value: 'Balanced',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {
            showMessage('Settings saved successfully');
          },
          icon: const Icon(Icons.save),
          label: const Text('Save Settings'),
        ),
        const SizedBox(height: 90),
      ],
    );
  }

  void applianceDetails(List<dynamic> item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                child: Icon(item[1], size: 35),
              ),
              const SizedBox(height: 12),
              Text(
                item[0],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Current usage: ${item[2]}'),
              const SizedBox(height: 15),
              const LinearProgressIndicator(value: 0.55),
              const SizedBox(height: 15),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  showMessage('${item[0]} optimized');
                },
                child: const Text('Optimize Usage'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void addApplianceDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Appliance'),
          content: Form(
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Appliance name',
                hintText: 'Example: Microwave',
                prefixIcon: Icon(Icons.devices),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                showMessage(
                  '${controller.text.isEmpty ? 'Appliance' : controller.text} added',
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void energyGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose Energy Goal'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                showMessage('Goal: Save 10% energy');
              },
              child: const Text('Save 10%'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                showMessage('Goal: Save 20% energy');
              },
              child: const Text('Save 20%'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                showMessage('Goal: Save 30% energy');
              },
              child: const Text('Save 30%'),
            ),
          ],
        );
      },
    );
  }
}