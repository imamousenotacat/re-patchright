import asyncio
from patchright.async_api import async_playwright, expect


async def test_cloudflare():
  async with (async_playwright() as playwright):
    chromium = playwright.chromium
    browser = await chromium.launch(headless=False)
    context = await browser.new_context()
    page = await context.new_page()
    await page.goto("https://nopecha.com/demo/cloudflare")

    # Create and check frame locator
    SELECTOR = "iframe[src^='https://challenges.cloudflare.com/cdn-cgi/challenge-platform']"
    frame_locator = page.frame_locator(SELECTOR)
    await expect(frame_locator.owner).to_have_count(1, timeout=10000)

    # Create, check and click locator for checkbox
    check_box_locator = frame_locator.locator("input[type=checkbox]")
    await expect(check_box_locator).to_be_visible(timeout=10000)
    await check_box_locator.click()

    await page.wait_for_timeout(timeout=5000)
    await browser.close()

if __name__ == "__main__":
  asyncio.run(test_cloudflare())
