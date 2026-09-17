import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/irrigation_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class IrrigationScreen extends StatefulWidget {
  const IrrigationScreen({super.key});

  @override
  State<IrrigationScreen> createState() => _IrrigationScreenState();
}

class _IrrigationScreenState extends State<IrrigationScreen> {
  double _duree = 12;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IrrigationProvider>().fetchEtat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IrrigationProvider>();
    final etat = provider.etat;
    final isAuto = (etat?.mode ?? 'auto') == 'auto';

    if (provider.isLoading && etat == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.green));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(
                  child: _ModeTab(
                    label: 'Automatique',
                    selected: isAuto,
                    onTap: () => context.read<IrrigationProvider>().setMode('auto'),
                  ),
                ),
                Expanded(
                  child: _ModeTab(
                    label: 'Manuel',
                    selected: !isAuto,
                    onTap: () => context.read<IrrigationProvider>().setMode('manuel'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (isAuto) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                    child: const Icon(Icons.water_drop, color: AppColors.greenDark),
                  ),
                  const SizedBox(height: 12),
                  const Text('Mode automatique activé', style: AppTextStyles.heading, textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  const Text(
                    "Le système déclenche l'irrigation dès que la prévision des besoins en eau l'indique, sans intervention de votre part.",
                    style: AppTextStyles.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Irrigation automatique', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Switch(
                        value: etat?.actif ?? false,
                        activeColor: AppColors.green,
                        onChanged: provider.isActing
                            ? null
                            : (v) => context.read<IrrigationProvider>().toggleAuto(v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Durée', style: AppTextStyles.bodyMuted),
                      Text('${_duree.toInt()} min', style: AppTextStyles.title(size: 22, color: AppColors.green)),
                    ],
                  ),
                  Slider(
                    value: _duree,
                    min: 1,
                    max: 30,
                    activeColor: AppColors.green,
                    inactiveColor: AppColors.line,
                    onChanged: (v) => setState(() => _duree = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if ((etat?.actif ?? false)) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  border: Border.all(color: AppColors.green),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: AppColors.green),
                        SizedBox(width: 8),
                        Text('Irrigation en cours', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.greenDark)),
                      ],
                    ),
                    if (etat?.dureeMinutes != null)
                      Text('${etat!.dureeMinutes} min', style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: "Arrêter l'irrigation",
                color: AppColors.danger,
                icon: Icons.stop_circle_outlined,
                loading: provider.isActing,
                onPressed: () => context.read<IrrigationProvider>().arreter(),
              ),
            ] else
              PrimaryButton(
                label: 'Déclencher maintenant',
                icon: Icons.water_drop_outlined,
                loading: provider.isActing,
                onPressed: () => context.read<IrrigationProvider>().declencher(dureeMinutes: _duree.toInt()),
              ),
          ],

          if (provider.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12.5), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
