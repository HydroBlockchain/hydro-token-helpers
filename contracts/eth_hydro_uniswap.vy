contract Snowflake():
  def hydroTokenAddress() -> address: constant

contract HydroToken():
  def approveAndCall(_spender: address, _value: uint256, _extraData: bytes[32]) -> bool: modifying

contract UniswapFactory():
  def getExchange(token: address) -> address: constant

contract UniswapHydroExchange():
  def ethToTokenSwapInput(min_tokens: uint256, deadline: timestamp) -> uint256: modifying
  def ethToTokenSwapOutput(tokens_bought: uint256, deadline: timestamp) -> uint256(wei): modifying

snowflakeAddress: public(address)
hydroTokenAddress: public(address)
uniswapFactoryAddress: public(address)
uniswapHydroExchangeAddress: public(address)
# _placeholder: bytes[1]

@public
def __init__(_snowflakeAddress: address, _uniswapFactoryAddress: address):
  self.snowflakeAddress = _snowflakeAddress
  _hydroTokenAddress: address = Snowflake(self.snowflakeAddress).hydroTokenAddress()
  assert (_hydroTokenAddress != ZERO_ADDRESS)
  self.hydroTokenAddress = _hydroTokenAddress

  self.uniswapFactoryAddress = _uniswapFactoryAddress
  _uniswapHydroExchangeAddress: address = UniswapFactory(self.uniswapFactoryAddress).getExchange(self.hydroTokenAddress)
  assert (_uniswapHydroExchangeAddress != ZERO_ADDRESS)
  self.uniswapHydroExchangeAddress = _uniswapHydroExchangeAddress

# @private
# def depositIntoSnowflake(tokens_to_deposit: uint256, recipient: address):
#   convertedRecipient: bytes[32] = slice(concat(convert(recipient, bytes32), self._placeholder), start=0, len=32)
#   assert HydroToken(self.hydroTokenAddress).approveAndCall(self, tokens_to_deposit, convertedRecipient)

@public
@payable
def swapAndDepositOutputTEST(tokens_bought: uint256, deadline: timestamp, recipient: address):
  _eth_sold: uint256(wei) = UniswapHydroExchange(self.uniswapHydroExchangeAddress).ethToTokenSwapOutput(tokens_bought, deadline, value=msg.value / 2)

  # id: bytes[4] = method_id("ethToTokenSwapOutput(uint256,uint256)", bytes[4])
  # data: bytes[64] = concat(convert(tokens_bought, bytes32), convert(deadline, bytes32))
  #
  # _eth_sold: bytes[32] = raw_call(self.uniswapHydroExchangeAddress, concat(id, convert(tokens_bought, bytes32), convert(deadline, bytes32)), outsize=32, gas=1000000, value=as_wei_value(1, "ether"))
  # eth_sold: uint256 = convert(_eth_sold, uint256)

  # self.depositIntoSnowflake(tokens_bought, recipient)

  # return tokens_bought

# @public
# @payable
# def swapAndDepositOutputTEST2(tokens_bought: uint256, deadline: timestamp):
#   id: bytes[4] = method_id("ethToTokenSwapOutput(uint256,uint256)", bytes[4])
#   # data: bytes[64] = concat(convert(tokens_bought, bytes32), convert(deadline, bytes32))
#
#   raw_call(self.uniswapHydroExchangeAddress, concat(id, convert(tokens_bought, bytes32), convert(deadline, bytes32)), outsize=0, gas=as_wei_value(1000000, "gwei"), value=as_wei_value(1, "ether"))
#   # eth_sold: uint256 = convert(_eth_sold, uint256)
#
#   # self.depositIntoSnowflake(tokens_bought, recipient)
#
#   # return tokens_bought
#
# @public
# @payable
# def swapAndDepositInput(min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
#   id: bytes[4] = method_id("ethToTokenTransferInput(uint256,uint256,address)", bytes[4])
#   data: bytes[96] = concat(
#     convert(min_tokens, bytes32), convert(deadline, bytes32), convert(self, bytes32)
#   )
#   _tokens_bought: bytes[32] = raw_call(
#     self.uniswapHydroExchangeAddress, concat(id, data), outsize=32, gas=msg.gas, value=msg.value
#   )
#   tokens_bought: uint256 = convert(_tokens_bought, uint256)
#
#   self.depositIntoSnowflake(tokens_bought, recipient)
#
#   return tokens_bought
#
# @public
# @payable
# def swapAndDepositOutput(tokens_bought: uint256, deadline: timestamp, recipient: address) -> uint256:
#   id: bytes[4] = method_id("ethToTokenTransferOutput(uint256,uint256,address)", bytes[4])
#   data: bytes[96] = concat(
#     convert(tokens_bought, bytes32), convert(deadline, bytes32), convert(self, bytes32)
#   )
#   _eth_sold: bytes[32] = raw_call(
#     self.uniswapHydroExchangeAddress, concat(id, data), outsize=32, gas=msg.gas, value=msg.value
#   )
#   eth_sold: uint256 = convert(_eth_sold, uint256)
#
#   self.depositIntoSnowflake(tokens_bought, recipient)
#
#   return tokens_bought
