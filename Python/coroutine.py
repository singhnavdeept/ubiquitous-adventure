import asyncio

async def main():
    print("Hello...")
    # Pause here for 1 second without blocking other tasks
    await asyncio.sleep(1)
    print("...World!")
# this main will return a async object  of type coroutine 
print(type(main()))

# Run the top-level entry point
asyncio.run(main())
