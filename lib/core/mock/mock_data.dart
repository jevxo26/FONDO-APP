import '../../../models/address_model.dart';

// ---------------------------------------------------------------------------
// Mock data for static demo phase. Used by screens via "Use Demo Data" buttons.
// ---------------------------------------------------------------------------

// ── Addresses ─────────────────────────────────────────────────────────────────

final mockAddresses = [
  const AddressModel(
    id: 'addr_demo_001',
    label: 'Home',
    street: 'House 42, Road 11, Block D',
    city: 'Banani, Dhaka',
    state: 'Dhaka Division',
    zipCode: '1213',
    country: 'Bangladesh',
    latitude: 23.7925,
    longitude: 90.4078,
    isDefault: true,
    deliveryInstructions: 'Leave at front desk',
  ),
  const AddressModel(
    id: 'addr_demo_002',
    label: 'Office',
    street: 'Level 5, Building B, Bashundhara R/A',
    city: 'Dhaka',
    state: 'Dhaka Division',
    zipCode: '1229',
    country: 'Bangladesh',
    latitude: 23.8103,
    longitude: 90.4381,
    isDefault: false,
    deliveryInstructions: null,
  ),
];

// ── Login form ────────────────────────────────────────────────────────────────

const mockLoginEmail = 'raihan@example.com';
const mockLoginPassword = 'secret123';

// ── Register form ─────────────────────────────────────────────────────────────

const mockRegisterFirstName = 'Raihan';
const mockRegisterLastName = 'Ahmed';
const mockRegisterPhone = '+8801712345678';
const mockRegisterEmail = 'raihan@example.com';
const mockRegisterPassword = 'secret123';

// ── Address form ──────────────────────────────────────────────────────────────

const mockReceiverName = 'Raihan Ahmed';
const mockReceiverPhone = '+8801712345678';
const mockDivision = 'Dhaka Division';
const mockDistrict = 'Banani, Dhaka';
const mockRoadHouse = 'House 42, Road 11, Block D';
const mockAddressDetail = 'Apt 5B, Floor 5';
const mockDeliveryInstructions = 'Leave at front desk';

// ── OTP ───────────────────────────────────────────────────────────────────────

const mockOtpCode = '123456';

// ── Error messages ────────────────────────────────────────────────────────────

const mockLoginError = 'Invalid email or password';
const mockNetworkError = 'Connection timed out. Please try again.';
const mockOtpError = 'Invalid verification code';
