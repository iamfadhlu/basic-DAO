# Basic DAO Project

A decentralized autonomous organization (DAO) implementation using OpenZeppelin contracts. The project includes governance token, timelock controller, and basic value storage functionality.

## Contracts

- `Box.sol`: Simple contract for storing and retrieving a number, controlled by governance
- `GovToken.sol`: ERC20 governance token with voting capabilities
- `MyGovernor.sol`: Main governance contract with voting settings and timelock control
- `Timelock.sol`: Controller for time-delayed execution of governance proposals

## Features

- ERC20Votes-based governance token
- Configurable voting delay (1 day) and voting period (1 week)
- 4% quorum requirement
- Time-locked execution of proposals
- Basic value storage controlled by governance

## Governance Process

1. **Proposal**: Any token holder can propose changes
2. **Voting Delay**: 7200 blocks (~1 day)
3. **Voting Period**: 50400 blocks (~1 week)
4. **Execution Delay**: Set during timelock deployment
5. **Quorum**: 4% of total token supply

## Testing

The test suite demonstrates the complete governance workflow:
1. Proposal creation
2. Voting
3. Queue
4. Execution

Run tests:
```bash
forge test
```

## Security

- Utilizes OpenZeppelin's battle-tested governance contracts
- Time-locked execution for additional security
- Role-based access control for proposal and execution permissions

## Dependencies

- OpenZeppelin Contracts ^5.0.0
- Forge Standard Library